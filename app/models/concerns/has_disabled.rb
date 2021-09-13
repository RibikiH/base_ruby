module HasDisabled
  extend ActiveSupport::Concern

  included do
    enumerize :disabled, in: {true: true, false: false}, default: :false

    validates :disabled,
      inclusion: self.disabled.values

    scope :enabled, -> {
      where(disabled: false)
    }
  end
  def enabled?
    self.disabled.false?
  end
end
