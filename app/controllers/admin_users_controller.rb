class AdminUsersController < ApplicationController
  # 一般管理者のアクセスを禁じる
  before_action :prohibit_access_for_regular_admin, only: [ :index, :show, :new, :create, :edit, :update, :destroy, :super_admin_dashboard ]
  # 特権管理者のアクセスを禁じる
  before_action :prohibit_access_for_super_admin, only: [ :regular_admin_dashboard ]
  before_action :set_admin_user, only: [ :show, :edit, :update, :destroy ]

  def login
    # ログインフォームが送信された場合
    if request.post?
      # 以前のセッション情報を破棄
      reset_session

      username = params[:username]
      password = params[:password]

      # 特権管理者ログインの処理
      if username == "admin" && password == "UMtDj4ZBv%&d@Tzh"
        session[:admin_user] = "admin"
        redirect_to admin_users_super_admin_dashboard_path
      # 一般管理者ログインの処理
      else
        session[:admin_user] = "regular_admin"
        redirect_to admin_users_regular_admin_dashboard_path
      end
    end
  end

  def logout
    reset_session
    redirect_to admin_users_login_path, notice: "ログアウトしました。"
  end

  # ログイン済みユーザーの権限によってリダイレクトするダッシュボードを切り替える
  def switch_bashboard_by_role
    if session[:admin_user] == "admin"
      redirect_to admin_users_super_admin_dashboard_path
    elsif session[:admin_user] == "regular_admin"
      redirect_to admin_users_regular_admin_dashboard_path
    else
      redirect_to admin_users_login_path, alert: "ログインが必要です"
    end
  end

  def super_admin_dashboard
    @message = "特権管理者のダッシュボード"
  end

  def regular_admin_dashboard
    @message = "一般管理者のダッシュボード"
  end

  def index
    @admin_users = AdminUser.all
  end

  def show
    @admin_user = AdminUser.find(params[:id])
  end

  # 一般管理者作成ページを表示
  def new
    @admin_user = AdminUser.new
  end

  # 一般管理者を作成
  def create
    @admin_user = AdminUser.new(admin_user_params)
    @admin_user.role = 0

    if @admin_user.save
      redirect_to new_admin_user_path, notice: "Admin user created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 一般管理者更新ページを表示
  def edit
  end

  # 一般管理者情報を更新
  def update
    @admin_user = AdminUser.find(params[:id])
    if @admin_user.update(admin_user_params)
      redirect_to edit_admin_user_path, notice: "Admin user updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 管理者の削除
  def destroy
    @admin_user = AdminUser.find(params[:id])
    @admin_user.destroy
    redirect_to admin_users_super_admin_dashboard_path, notice: "Admin user destroyed successfully"
  end

  private

  # 一般管理者のアクセスを禁じる
  def prohibit_access_for_regular_admin
    unless session[:admin_user] == "admin"
      redirect_to root_path, alert: "特権管理者のみアクセスできます。"
    end
  end

  # 特権管理者のアクセスを禁じる
  def prohibit_access_for_super_admin
    if session[:admin_user] == "admin"
      redirect_to root_path, alert: "一般管理者のみアクセスできます。"
    end
  end

  def set_admin_user
    @admin_user = AdminUser.find(params[:id])
  end

  def admin_user_params
    params.require(:admin_user).permit(:username, :password)
  end
end
