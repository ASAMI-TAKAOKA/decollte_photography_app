class Admin::DashboardsController < ApplicationController
  before_action :authenticate_admin_user

  def show
  end

  private

  # session[:admin_role] の値が 0 または 1 の場合のみログインを許可する
  def authenticate_admin_user
    unless session[:admin_role].in?([0, 1])
      redirect_to new_admin_session_path, alert: "ログインが必要です。"
    end
  end
end
