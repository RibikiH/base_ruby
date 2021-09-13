module DbCreatedAt
  extend ActiveSupport::Concern

  included do
    scope :in_this_month, -> { 
      beginning_of_month = Time.now.beginning_of_month.midnight
      end_of_month = beginning_of_month.next_month
      where(arel_table['created_at'].gteq beginning_of_month).where(arel_table['created_at'].lt end_of_month) 
    }
    scope :in_last_month, -> { 
      beginning_of_month = Time.now.beginning_of_month.midnight.prev_month
      end_of_month = beginning_of_month.next_month
      where(arel_table['created_at'].gteq beginning_of_month).where(arel_table['created_at'].lt end_of_month) 
    }

    scope :at_this_month, -> { 
      end_of_month = Time.now.beginning_of_month.midnight.next_month
      where(arel_table['created_at'].lt end_of_month) 
    }
    scope :at_last_month, -> { 
      end_of_month = Time.now.beginning_of_month.midnight
      where(arel_table['created_at'].lt end_of_month) 
    }

    def self.ransackable_scopes(auth_object = nil)
      [:in_this_month, :in_last_month]
    end
  end
end