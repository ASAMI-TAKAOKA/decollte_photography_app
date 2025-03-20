class AdminUsersController < ApplicationController
  before_action :authenticate_admin_user, except: %i[ login ]
  before_action :prohibit_access_for_regular_admin, only: %i[ index show new create edit update destroy ]
  before_action :set_admin_user, only: %i[ show edit update destroy ]

  def dashboard
  end

  def login
    if request.post?
      reset_session

      username = params[:username]
      password = params[:password]

      if username == "admin" && password == "UMtDj4ZBv%&d@Tzh"
        session[:admin_user] = "admin"
      else
        session[:admin_user] = "regular_admin"
      end

      flash[:notice] = "ログインしました。"
      redirect_to admin_dashboard_path
    else
      render :login
    end
  end

  def logout
    reset_session
    flash[:notice] = "ログアウトしました。"
    redirect_to admin_users_login_path
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
      flash[:notice] = "Admin user created successfully"
      redirect_to new_admin_user_path
    else
      render :new, status: :unprocessable_entity # Turboに対応
    end
  end

  # 一般管理者更新ページを表示
  def edit
  end

  # 一般管理者情報を更新
  def update
    @admin_user = AdminUser.find(params[:id])
    if @admin_user.update(admin_user_params)
      flash[:notice] = "Admin user updated successfully"
      redirect_to edit_admin_user_path
    else
      render :edit, status: :unprocessable_entity # Turboに対応
    end
  end

  # 管理者の削除
  def destroy
    @admin_user = AdminUser.find(params[:id])
    @admin_user.destroy
    flash[:notice] = "Admin user destroyed successfully"
    redirect_to admin_users_path
  end

  private

  def authenticate_admin_user
    unless session[:admin_user] == "admin" || session[:admin_user] == "regular_admin"
      flash[:alert] = "ログインが必要です。"
      redirect_to admin_users_login_path
    end
  end

  # 一般管理者のアクセスを禁じる
  def prohibit_access_for_regular_admin
    unless session[:admin_user] == "admin"
      flash[:alert] = "特権管理者のみアクセスが可能です。"
      redirect_to root_path
    end
  end

  def set_admin_user
    @admin_user = AdminUser.find(params[:id])
  end

  def admin_user_params
    params.require(:admin_user).permit(:username, :password)
  end
end
