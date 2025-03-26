class StoresController < ApplicationController
  before_action :set_brand, only: %i[ new create show edit update destroy move_higher_within_brand move_lower_within_brand ]
  before_action :set_store, except: %i[ index new create ]
  before_action :prohibit_access_for_regular_admin, only: %i[ show new create edit update destroy ]

  def index
    @stores = Store.order(:global_position)
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

  # (Review)
  # ここ以降の `move_` がプレフィックスに付いている並び替えを行うためのアクションは、別のコントローラで実装した方がよいです。
  # このコントローラは店舗のCRUD操作を行うためのコントローラです。それ以外の処理は別のコントローラで実装しましょう。
  # またこの手のロジックはコントローラではなく、モデルに実装するべきです。
  def move_higher_global
    store = Store.find(params[:id])
    previous_store = Store.where("global_position < ?", store.global_position).order(global_position: :desc).first

    if previous_store
      Store.transaction do
        swap_global_positions(store, previous_store)
      end
    end

    flash[:notice] = "店舗の順番を変更しました。"
    redirect_to stores_path
  end

  def move_lower_global
    store = Store.find(params[:id])
    next_store = Store.where("global_position > ?", store.global_position).order(:global_position).first

    if next_store
      Store.transaction do
        swap_global_positions(store, next_store)
      end
    end

    flash[:notice] = "店舗の順番を変更しました。"
    redirect_to stores_path
  end

  # ブランド内で上に移動
  def move_higher_within_brand
    store = Store.find(params[:id])
    store.move_higher

    flash[:notice] = "店舗の順番を変更しました。"
    redirect_to brand_path(@brand.slug)
  end

  # ブランド内で下に移動
  def move_lower_within_brand
    store = Store.find(params[:id])
    store.move_lower

    flash[:notice] = "店舗の順番を変更しました。"
    redirect_to brand_path(@brand.slug)
  end

  private

  def swap_global_positions(store1, store2)
    store1_global_position = store1.global_position
    store1.update!(global_position: store2.global_position)
    store2.update!(global_position: store1_global_position)
  end

  def set_brand
    # (Review)
    # ここはロジックがめちゃくちゃです。
    # そもそもfind_by!で見つからなかった場合は例外が発生しますので、else文内の処理は実行されません
    # この１行だけあれば済むと思います。 @brand = Brand.find_by!(slug: params[:brand_slug])
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
