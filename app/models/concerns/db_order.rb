module DbOrder
  extend ActiveSupport::Concern

  included do
    scope :status_pay, -> { 
      where(arel_table['status'].eq 'pay')
    }
    scope :status_judge, -> { 
      where(arel_table['status'].eq 'judge')
    }
    scope :self_service_transfer, -> { 
      where(arel_table['status'].eq 'transfer').where(arel_table['self_service'].eq true)
    }
    scope :ready_for_remit, -> { 
      where(arel_table['status'].eq 'ready').where(arel_table['self_service'].eq false)
    }

    def self.ransackable_scopes(auth_object = nil)
      [:status_pay, :status_judge, :self_service_transfer]
    end
  end
end