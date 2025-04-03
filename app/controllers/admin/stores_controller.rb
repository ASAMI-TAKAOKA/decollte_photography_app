class Admin::StoresController < ApplicationController
  before_action :check_login
  before_action :set_brand, only: %i[new create show edit update destroy ]
  before_action :set_store, only: %i[show edit update destroy]
  before_action :prohibit_access_for_regular_admin, only: %i[show new create edit destroy]

  def index
    @stores = Store.all
  end

  def show
  end

  def new
    @store = @brand.stores.build
  end

  def create
    @store = @brand.stores.build(store_params)

    if @store.save
      redirect_to admin_brand_path(@brand), notice: "店舗が作成されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # 並び順の変更処理
    if (direction = store_params[:direction]&.to_sym)
      scope_type = store_params[:scope_type]&.to_sym || :brand

      if %i[higher lower].include?(direction)
        @store.move(direction, scope_type: scope_type)
        redirect_to(scope_type == :all ? admin_stores_path : admin_brand_path(@brand), notice: "店舗の順番を変更しました。") and return
      end
    end

    # 権限チェック
    unless session[:admin_role] == 1
      redirect_to admin_dashboards_path, alert: "特権管理者のみアクセスが可能です。" and return
    end

    # 店舗情報の更新処理
    if @store.update(store_params.except(:direction, :scope_type))
      redirect_to admin_brand_path(@brand), notice: "店舗情報が更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @store.destroy
    redirect_to admin_brand_path(@brand), notice: "店舗が削除されました。"
  end

  private

  def set_brand
    return if params[:store]&.dig(:scope_type) == "all" # scope_type が all の場合は @brand をセットしない

    @brand = Brand.find_by!(slug: params[:brand_slug])
  end

  def set_store
    @store = Store.find(params[:id])
  end

  def prohibit_access_for_regular_admin
    unless session[:admin_role] == 1
      redirect_to admin_dashboards_path, alert: "特権管理者のみアクセスが可能です。"
    end
  end

  def store_params
    params.require(:store).permit(:name, :address, :phone_number, :direction, :scope_type)
  end
end
