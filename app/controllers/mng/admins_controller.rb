class Mng::AdminsController < Mng::BaseController
  include Crud
  self.sorts = "id desc"

  def invite
    find_item
    @item.send_reset_password_instructions
    redirect_to(url_after_destroy, {notice: model.model_name.human+I18n.t('actions.invited')})
  end

  private
  def permitted_params
    attrs = [:name, :email]
    attrs += [:password, :password_confirmation] if @item == current_admin
    params.require(:item).permit(attrs)
  end
  def before_create
    @item.password = SecureRandom.uuid
  end
  def before_update
    @item.clean_up_passwords if @item.password.blank?
  end
end
