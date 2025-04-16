class Admin::SessionsController < Admin::BaseController
  skip_before_action :check_login
  before_action :check_auth_and_redirect, only: %i[ new create ]

  def new
  end

  def create
    admin_user = AdminUser.find_by(username: params[:username])

    if admin_user&.authenticate(params[:password])
      session[:admin_user_id] = admin_user.id
      redirect_to admin_root_path, notice: "ログインしました。"
    else
      redirect_to new_admin_session_path, alert: "ログイン情報が正しくありません。"
    end
  end

  def destroy
    reset_session
    redirect_to new_admin_session_path, notice: "ログアウトしました。"
  end

  private

  def check_auth_and_redirect
    redirect_to admin_root_path, notice: "すでにログインしています。" if admin_logged_in?
  end
end
