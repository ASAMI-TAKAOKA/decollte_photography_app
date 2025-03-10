# app/controllers/stores_controller.rb
class StoresController < ApplicationController
  before_action :set_brand
  before_action :set_store, only: [ :show, :edit, :update, :destroy, :move_higher, :move_lower ]

  # 店舗一覧ページ
  def index
    @stores = @brand.stores
  end

  # 店舗詳細ページ
  def show
  end

  # 店舗新規作成フォーム
  def new
    @store = @brand.stores.build
  end

  # 店舗作成
  def create
    @store = @brand.stores.build(store_params)
    if @store.save
      redirect_to brand_stores_path(@brand), notice: "店舗が作成されました。"
    else
      render :new
    end
  end

  # 店舗編集フォーム
  def edit
  end

  # 店舗更新
  def update
    if @store.update(store_params)
      redirect_to brand_store_path(@brand, @store), notice: "店舗情報が更新されました。"
    else
      render :edit
    end
  end

  # 店舗削除
  def destroy
    @store.destroy
    redirect_to brand_stores_path(@brand), notice: "店舗が削除されました。"
  end

  # 上へ移動
  def move_higher
    @store.move_higher
    redirect_to brand_stores_path(@brand), notice: "店舗の並び順を変更しました。"
  end

  # 下へ移動
  def move_lower
    @store.move_lower
    redirect_to brand_stores_path(@brand), notice: "店舗の並び順を変更しました。"
  end

  private

  # ブランドのセット
  def set_brand
    @brand = Brand.find(params[:brand_id])
  end

  # 店舗のセット
  def set_store
    @store = @brand.stores.find(params[:id])
  end

  # 店舗パラメータの許可
  def store_params
    params.require(:store).permit(:name, :address, :phone_number)
  end
end
