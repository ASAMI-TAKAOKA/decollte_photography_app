class Admin::StoresController < ApplicationController
  before_action :authenticate_admin_user
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

    if Store.exists?(name: @store.name)
      flash[:alert] = "#{@store.name}という店舗名はすでに存在します。"
      render :new, status: :unprocessable_entity
    elsif @store.save
      redirect_to admin_brand_path(@brand), notice: "店舗が作成されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # direction パラメータがある場合、店舗の順番を変更する
    direction = store_params[:direction]
    if direction.present?
      direction = direction.to_sym
      if %i[higher lower].include?(direction)
        @store.move_within_brand(direction)
      end

      redirect_to admin_brand_path(@brand.slug), notice: "店舗の順番を変更しました。" and return
    end

    unless session[:admin_role] == 1
      redirect_to admin_dashboards_path, alert: "特権管理者のみアクセスが可能です。"
    else
      # 店舗情報（店舗の順番以外）の更新
      if @store.update(store_params.except(:direction))
        redirect_to admin_brand_path(@brand), notice: "店舗情報が更新されました。"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @store.destroy
    redirect_to admin_brand_path(@brand), notice: "店舗が削除されました。"
  end

  private

  def set_brand
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
    params.require(:store).permit(:name, :address, :phone_number, :direction)
  end

  # session[:admin_role] の値が 0 または 1 の場合のみログインを許可する
  def authenticate_admin_user
    unless session[:admin_role].in?([0, 1])
      redirect_to new_admin_session_path, alert: "ログインが必要です。"
    end
  end
end
