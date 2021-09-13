module DetectParent
  extend ActiveSupport::Concern
  
  included do
    class_attribute :parent_model
    class_attribute :parent_param
    
    before_action :instantize_parent_model
    before_action :find_parent
  end

  private
  def instantize_parent_model
    if parent_param.nil?
      parent_param = "#{params[:parent]}_id"
      parent_model = params[:parent].classify.safe_constantize
    end
    @parent_model = parent_model
    @parent_param = parent_param
  end
  def find_parent
    @parent_item = @parent_model.find(params[@parent_param])
  end
end