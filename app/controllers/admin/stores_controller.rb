class Admin::StoresController < ApplicationController
  before_action :check_login
  before_action :set_brand, only: %i[ new create show edit update destroy ]
  before_action :set_store, only: %i[ show edit update destroy ]
  before_action :prohibit_access_for_regular_admin, only: %i[ show new create edit destroy ]

  def index
    @grouped_stores = Store.includes(:brand).order(:brand_id, :position).group_by(&:brand)
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
    if (direction = store_params[:direction]&.to_sym) && %i[higher lower].include?(direction)
      @store.move(direction)
      redirect_to admin_brand_path(@brand), notice: "店舗の順番を変更しました。" and return
    end

    # 権限チェックと店舗情報の更新処理
    return redirect_to admin_root_path, alert: "特権管理者のみアクセスが可能です。" unless super_admin?

    if @store.update(store_params.except(:direction))
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
    @brand = Brand.find_by!(slug: params[:brand_id]) # idではなくslugでブランドを特定する
  end

  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    params.require(:store).permit(:name, :address, :phone_number, :direction)
  end
end
