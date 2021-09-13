module FnOrder
  extend ActiveSupport::Concern

  def total_fee
    self.service_fee + self.service_tax + self.fix_fee + self.fix_tax
  end
  def self_service_transfer?
    self.status.transfer? && self.self_service?
  end
  
  def calc_fees
    _calc_fees(false)
  end
  def calc_fees_and_save
    _calc_fees(true)
  end

  def cancelable?
    %w(pay judge ready).include? self.status
  end
  
  private
  def _calc_fees(store)
    user = self.user
    company = user.company
    vat = Fn.vat

    self.amount = self.amount.to_i
    self.self_service = company.self_service
    
    if company.auto_allow.false?
      self.status = 'judge'
    elsif self.kind.pay?
      self.status = 'pay'
    elsif self.self_service?
      self.status = 'transfer'
    else
      self.status = 'ready'
    end
     
    if self.self_service?
      self.service_fee = company.self_fee
      self.service_tax = self.service_fee * vat
      self.fix_fee     = 0
      self.fix_tax     = self.fix_fee * vat

      case self.kind.value
      when "transfer"
        self.transfer = 0
        self.cash_out = 0
        self.cash_in  = self.total_fee
      when "salary"
        self.transfer = 0
        self.cash_out = 0
        self.cash_in  = self.total_fee
      when "pay"
        self.transfer = 0
        self.cash_out = 0
        self.cash_in  = 0
      end
      
    else
      self.service_fee = self.amount * company.service_fee / 100
      self.service_tax = self.service_fee * vat
      self.fix_fee     = company.fix_fee
      self.fix_tax     = self.fix_fee * vat

      case self.kind.value
      when "transfer"
        self.transfer = self.amount - self.total_fee
        self.cash_out = self.transfer + self.fix_fee + self.fix_tax
        self.cash_in  = self.amount
      when "salary"
        self.transfer = self.amount
        self.cash_out = self.transfer + self.fix_fee + self.fix_tax
        self.cash_in  = self.amount + self.total_fee
      when "pay"
        self.transfer = self.amount
        self.cash_out = self.transfer + self.fix_fee + self.fix_tax
        self.cash_in  = self.amount
      end
    end
    
    return false unless self.valid?
    
    self.transaction do
      user.reload(lock: true)
      available_amount = user.available_amount
      
      if self.amount > available_amount
        self.errors.add(:amount, :less_than_or_equal_to, count: available_amount)
        return false
      end
      
      if store==true
        self.save
      else
        true
      end
    end
  end
end