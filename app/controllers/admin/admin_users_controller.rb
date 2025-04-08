class Admin::AdminUsersController < Admin::BaseController
  before_action :prohibit_access_for_regular_admin, only: %i[ index show new create edit update destroy ]
  before_action :set_admin_user, only: %i[ show edit update destroy ]

  def index
    @admin_users = AdminUser.all
  end

  def show
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
      redirect_to admin_admin_users_path, notice: "一般管理者を作成しました。"
    else
      render :new, status: :unprocessable_entity # Turboに対応
    end
  end

  # 一般管理者更新ページを表示
  def edit
  end

  # 一般管理者情報を更新
  def update
    if @admin_user.update(admin_user_params)
      redirect_to admin_admin_users_path, notice: "一般管理者情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity # Turboに対応
    end
  end

  # 管理者の削除
  def destroy
    # 管理者ユーザーが1人しかいない場合は削除できないようにする
    if AdminUser.count == 1
      redirect_to admin_admin_users_path, alert: "最後の管理者は削除できません。" and return
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
