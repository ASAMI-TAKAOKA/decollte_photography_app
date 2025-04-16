class Admin::AdminUsersController < Admin::BaseController
  before_action :prohibit_access_for_regular_admin
  before_action :set_admin_user, only: %i[ show edit update destroy ]

  def index
    @admin_users = AdminUser.all
  end

  def show
  end

  def new
    @admin_user = AdminUser.new
  end

  def create
    @admin_user = AdminUser.new(admin_user_params)
    @admin_user.role = 0

    if @admin_user.save
      redirect_to admin_admin_users_path, notice: "一般管理者を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @admin_user.update(admin_user_params)
      redirect_to admin_admin_users_path, notice: "一般管理者情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @admin_user.super_admin? && AdminUser.super_admin.count == 1
      return redirect_to admin_admin_users_path, alert: "特権管理者は削除できません。"
    end

    @admin_user.destroy
    redirect_to admin_admin_users_path, notice: "一般管理者を削除しました。"
  end

  private

  def set_admin_user
    @admin_user = AdminUser.find(params[:id])
  end

  def admin_user_params
    params.require(:admin_user).permit(:username, :password)
  end
end
