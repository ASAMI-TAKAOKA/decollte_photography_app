class Admin::SessionsController < ApplicationController
  def new
    if session[:admin_user_id].present?
      redirect_to admin_dashboards_path, notice: "すでにログインしています。"
    else
      render :new
    end
  end

  def create
    if session[:admin_user_id].present?
      redirect_to admin_dashboards_path, notice: "すでにログインしています。"
      return
    end
    # 管理者認証を DB に基づいて行う
    admin_user = AdminUser.find_by(username: params[:username])

    if admin_user&.authenticate(params[:password])
      session[:admin_user_id] = admin_user.id
      session[:admin_role] = admin_user.role # 0: 一般管理者, 1: 特権管理者

      redirect_to admin_dashboards_path, notice: "ログインしました。"
    else
      redirect_to new_admin_session_path, alert: "ログイン情報が正しくありません。"
    end
  end

  def destroy
    reset_session
    redirect_to new_admin_session_path, notice: "ログアウトしました。"
  end
end
