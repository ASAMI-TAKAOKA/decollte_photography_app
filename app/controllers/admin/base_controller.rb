module Admin
  class BaseController < ApplicationController
    before_action :check_login
    helper_method :current_user, :admin_logged_in?

    private

    def check_login
      redirect_to new_admin_session_path, alert: "ログインが必要です。" unless session[:admin_user_id]
    end

    def current_user
      return nil unless session[:admin_user_id].present?

      @admin_user ||= AdminUser.find(session[:admin_user_id])
    end

    def admin_logged_in?
      session[:admin_user_id].present?
    end

    def prohibit_access_for_regular_admin
      redirect_to admin_root_path, alert: "特権管理者のみアクセスが可能です。" unless current_user.super_admin?
    end
  end
end
