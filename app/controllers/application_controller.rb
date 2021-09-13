class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :set_paper_trail_whodunnit

  layout :layout_by_resource

  def namespace
    controller_path.split('/')[-2]
  end

  protected
  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def user_for_paper_trail
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  private
  def after_sign_out_path_for(resource)
    case resource.to_s
    when 'admin'
      new_admin_session_path
    when 'staff'
      new_staff_session_path
    else
      new_agent_session_path
    end
  end
end
