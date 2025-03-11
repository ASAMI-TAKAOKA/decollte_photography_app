class AdminUsersController < ApplicationController
  # 特権管理者のみアクセス可能
  before_action :authenticate_admin, only: [ :index, :create, :update, :destroy ]
  before_action :check_permissions, only: [ :create, :update ]
  before_action :set_admin_user, only: [ :show, :edit, :update, :destroy ]

  def login
    # ログインフォームが送信された場合
    if request.post?
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

  # 特権管理者のみ許可する認証メソッド
  def authenticate_admin
    unless session[:admin_user] == "admin"
      redirect_to admin_users_login_path, alert: "このページへは、特権管理者しかログインできません。"
    end
  end

  def check_permissions
    unless session[:admin_user] == "admin" || current_user.role == 0
      redirect_to root_path, alert: "アクセス権限がありません。"
    end
  end

  def set_admin_user
    @admin_user = AdminUser.find(params[:id])
  end

  def admin_user_params
    params.require(:admin_user).permit(:username, :password)
  end
end
