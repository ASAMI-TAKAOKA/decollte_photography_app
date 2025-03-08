class AdminUsersController < ApplicationController
  # 特権管理者のみアクセス可能
  before_action :authenticate_admin, only: [:create, :update, :destroy]
  before_action :check_permissions, only: [:create, :update]

  def login
    # ログインフォームが送信された場合
    if request.post?
      username = params[:username]
      password = params[:password]

      # 特権管理者ログインの処理（例）
      if username == 'admin' && password == 'UMtDj4ZBv%&d@Tzh'
        session[:admin_user] = 'admin'
        redirect_to admin_users_dashboard_path
      else
        flash.now[:alert] = 'ユーザ名またはパスワードが正しくありません。'
      end
    end
  end

  def dashboard
    # ダッシュボードの表示処理（例）
    if session[:admin_user] == 'admin'
      @message = '特権管理者のダッシュボード'
    else
      @message = '一般管理者のダッシュボード'
    end
  end

  # 一般管理者を作成
  def create
    @admin_user = AdminUser.new(admin_user_params)
    if @admin_user.save
      redirect_to admin_users_login_path, notice: 'Admin user created successfully'
    else
      render :new
    end
  end

  # 一般管理者情報を更新
  def update
    @admin_user = AdminUser.find(params[:id])
    if @admin_user.update(admin_user_params)
      redirect_to admin_users_login_path, notice: 'Admin user updated successfully'
    else
      render :edit
    end
  end

  # 管理者の削除
  def destroy
    @admin_user = AdminUser.find(params[:id])
    @admin_user.destroy
    redirect_to admin_users_login_path, notice: 'Admin user destroyed successfully'
  end

  private

  def authenticate_admin
    unless session[:admin_user] == 'admin'
      redirect_to admin_users_login_path, alert: 'このページへは、特権管理者しかログインできません。'
    end
  end

  def check_permissions
    unless session[:admin_user] == 'admin' || current_user.role == 0
      redirect_to root_path, alert: 'アクセス権限がありません。'
    end
  end

  def admin_user_params
    params.require(:admin_user).permit(:username, :password, :role)
  end
end
