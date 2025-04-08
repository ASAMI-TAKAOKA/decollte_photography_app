class Admin::SessionsController < Admin::BaseController
  skip_before_action :check_login

  def new
    if admin_logged_in?
      redirect_to admin_root_path, notice: "すでにログインしています。"
    else
      render :new
    end
  end

  def create
    if admin_logged_in?
      redirect_to admin_root_path, notice: "すでにログインしています。"
      return
    end
    # 管理者認証を DB に基づいて行う
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
end
