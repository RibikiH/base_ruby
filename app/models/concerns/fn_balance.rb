module FnBalance
  extend ActiveSupport::Concern

  def save_with_share_row_exclusive
    company = self.company
    company.with_lock do
      self.class.connection.execute 'LOCK TABLE balances IN SHARE ROW EXCLUSIVE MODE'
      total_amount = Balance.total_amount
      self.total_amount = total_amount + self.amount.to_i
      self.available_amount = company.available_amount + self.amount.to_i
      company.available_amount = self.available_amount
      
      self.save!
      company.save!
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
  
  module ClassMethods
    def total_amount
      self.order(:id).select(:total_amount).last.try(:total_amount) || 0
    end
  end
end
