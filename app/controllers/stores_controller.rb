# app/controllers/stores_controller.rb
class StoresController < ApplicationController
  before_action :set_brand
  before_action :set_store, except: [ :index, :new, :create ]
  before_action :prohibit_access_for_regular_admin, only: %i[ show new create edit update destroy ]

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

    if Store.exists?(name: @store.name)
      flash[:alert] = "#{@store.name}という店舗名はすでに存在します。"
      render :new, status: :unprocessable_entity # Turboに対応
    else
      if @store.save
        flash[:notice] = "店舗が作成されました。"
        redirect_to brand_stores_path(@brand)
      else
        render :new, status: :unprocessable_entity # Turboに対応
      end
    end
  end

  # 店舗編集フォーム
  def edit
  end

  # 店舗更新
  def update
    if @store.update(store_params)
      flash[:notice] = "店舗情報が更新されました。"
      redirect_to brand_store_path(@brand, @store)
    else
      render :edit, status: :unprocessable_entity # Turboに対応
    end
  end

  # 店舗削除
  def destroy
    @store.destroy
    flash[:notice] = "店舗が削除されました。"
    redirect_to brand_stores_path(@brand)
  end

  # 上へ移動
  def move_higher
    @store.move_higher
    flash[:notice] = "店舗の並び順を変更しました。"
    redirect_to brand_stores_path(@brand)
  end

  # 下へ移動
  def move_lower
    @store.move_lower
    flash[:notice] = "店舗の並び順を変更しました。"
    redirect_to brand_stores_path(@brand)
  end

  private

  # ブランドのセット
  def set_brand
    Rails.logger.debug "params[:brand_slug]: #{params[:brand_slug]}"
    @brand = Brand.find_by!(slug: params[:brand_slug])
    unless @brand
      flash[:alert] = "ブランドが見つかりません。"
      redirect_to root_path
    end
  end

  # 店舗のセット
  def set_store
    @store = @brand.stores.find(params[:id])
    unless @store
      flash[:alert] = "店舗が見つかりません。"
      redirect_to brand_stores_path(@brand)
    end
  end

  # 一般管理者のアクセスを禁じる
  def prohibit_access_for_regular_admin
    unless session[:admin_user] == "admin"
      flash[:alert] = "特権管理者のみアクセスが可能です。"
      redirect_to root_path
    end
  end

  # 店舗パラメータの許可
  def store_params
    params.require(:store).permit(:name, :address, :phone_number)
  end
end
