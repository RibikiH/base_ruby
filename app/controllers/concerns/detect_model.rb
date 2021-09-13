module DetectModel
  extend ActiveSupport::Concern
  
  included do
    class_attribute :model
    self.model = self.to_s.remove(/Controller$/).demodulize.classify.safe_constantize

    before_action :find_item, only: %w(show edit update destroy)
    before_action :instantize_model
  end

  private
  def instantize_model
    @model = model
  end
  def find_item
    @item = model.find(params[:id])
  end
end