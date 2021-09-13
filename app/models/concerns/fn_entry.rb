module FnEntry
  extend ActiveSupport::Concern
  def cancelable?
    %w(pay ready).include? self.status
  end
end