module DbEntry
  extend ActiveSupport::Concern

  included do
    scope :ready_for_remit, -> {
      where(arel_table['status'].eq 'ready')
    }
    scope :today, -> {
      beginning_of_day = Time.now.beginning_of_day
      where(arel_table['created_at'].gteq beginning_of_day)
    }
    scope :yesterday, -> {
      beginning_of_yesterday = 1.day.ago.beginning_of_day
      end_of_yesterday = 1.day.ago.end_of_day
      where(arel_table['created_at'].gteq beginning_of_yesterday).where(arel_table['created_at'].lteq end_of_yesterday)
    }
    scope :in_this_week, -> {
      beginning_of_the_week = Date.today.at_beginning_of_week.beginning_of_day
      where(arel_table['created_at'].gteq beginning_of_the_week)
    }
    scope :in_last_week, -> {
      beginning_of_the_week = 1.week.ago.at_beginning_of_week.beginning_of_day
      end_of_week = Date.today.at_beginning_of_week.beginning_of_day
      where(arel_table['created_at'].gteq beginning_of_the_week).where(arel_table['created_at'].lt end_of_week)
    }
  end
end