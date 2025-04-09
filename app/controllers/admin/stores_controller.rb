class Admin::StoresController < Admin::BaseController
  before_action :set_brand, only: %i[ new create show edit update destroy ]
  before_action :set_store, only: %i[ show edit update destroy ]
  before_action :prohibit_access_for_regular_admin, only: %i[ show new create edit update destroy ]

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
    if @store.update(store_params)
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
    @brand = Brand.friendly.find(params[:brand_id])
  end

  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    params.require(:store).permit(:name, :address, :phone_number)
  end
end
