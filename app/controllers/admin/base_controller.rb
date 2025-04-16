module Admin
  class BaseController < ApplicationController
    before_action :check_login

    private

    def check_login
      redirect_to new_admin_session_path, alert: "ログインが必要です。" unless session[:admin_user_id]
    end

    def prohibit_access_for_regular_admin
      redirect_to admin_root_path, alert: "特権管理者のみアクセスが可能です。" unless current_user.super_admin?
    end
  end
end
