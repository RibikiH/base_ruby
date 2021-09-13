module Mng
  class BaseController < ApplicationController
    before_action :authenticate_admin!
    before_action :prepare_exception_notifier

    layout 'admin'

    private
    def prepare_exception_notifier
      request.env["exception_notifier.exception_data"] = {
          current_admin: current_admin.id
      }
      logger.info current_admin.to_gid
    end

    protected
    def user_for_paper_trail
      current_admin
    end
  end
end
