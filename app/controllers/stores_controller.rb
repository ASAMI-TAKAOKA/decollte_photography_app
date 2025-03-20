class StoresController < ApplicationController
  before_action :set_brand, only: %i[ new create show edit update destroy move_higher_within_brand move_lower_within_brand ]
  before_action :set_store, except: %i[ index new create ]
  before_action :prohibit_access_for_regular_admin, only: %i[ show new create edit update destroy ]

  def index
    @stores = Store.order(:position)
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
    else
      if @store.save
        flash[:notice] = "店舗が作成されました。"
        redirect_to brand_path(@brand)
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
  end

  def update
    if @store.update(store_params)
      flash[:notice] = "店舗情報が更新されました。"
      redirect_to brand_store_path(@brand, @store)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @store.destroy
    flash[:notice] = "店舗が削除されました。"
    redirect_to brand_path(@brand)
  end

  def move_higher
    @store.move_higher
    flash[:notice] = "店舗の順番を変更しました。"
    redirect_to stores_path
  end

  def move_lower
    @store.move_lower
    flash[:notice] = "店舗の順番を変更しました。"
    redirect_to stores_path
  end

  def move_higher_within_brand
    @store.move_higher # acts_as_list の move_higher を使用
    flash[:notice] = "店舗の順番を変更しました。"
    redirect_to brand_stores_path
  end

  def move_lower_within_brand
    @store.move_lower # acts_as_list の move_lower を使用
    flash[:notice] = "店舗の順番を変更しました。"
    redirect_to brand_stores_path
  end

  private

  def set_brand
    if params[:brand_slug]
      @brand = Brand.find_by!(slug: params[:brand_slug])
    else
      flash[:alert] = "ブランドが見つかりません。"
      redirect_to root_path
    end
  end

  def set_store
    @store = Store.find(params[:id])
  end

  def prohibit_access_for_regular_admin
    unless session[:admin_user] == "admin"
      flash[:alert] = "特権管理者のみアクセスが可能です。"
      redirect_to root_path
    end
  end

  def store_params
    params.require(:store).permit(:name, :address, :phone_number)
  end
end
