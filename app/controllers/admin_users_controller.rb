class AdminUsersController < ApplicationController
  # 管理者でないとアクセスできないアクションに制限をかける
  before_action :check_admin, only: [:create, :update, :destroy]

  def index
    @admin_users = AdminUser.all
  end

  def show
    @admin_user = AdminUser.find(params[:id])
  end

  def create
    @admin_user = AdminUser.new(admin_user_params)
    if @admin_user.save
      redirect_to @admin_user, notice: 'Admin user was successfully created.'
    else
      render :new
    end
  end

  def update
    @admin_user = AdminUser.find(params[:id])
    if @admin_user.update(admin_user_params)
      redirect_to @admin_user, notice: 'Admin user was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @admin_user = AdminUser.find(params[:id])
    @admin_user.destroy
    redirect_to admin_users_url, notice: 'Admin user was successfully destroyed.'
  end

  private

  # 管理者かどうかを確認
  def check_admin
    unless current_user.role == 1  # roleが1でないユーザーは管理者ではない
      redirect_to root_path, alert: 'You do not have permission to perform this action.'  # アクセス拒否
    end
  end

  def admin_user_params
    params.require(:admin_user).permit(:username, :password, :role)
  end
end
