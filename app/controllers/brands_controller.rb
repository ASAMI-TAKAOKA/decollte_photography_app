class BrandsController < ApplicationController
  before_action :set_brand, only: %i[ show edit update destroy ]
  before_action :prohibit_access_for_regular_admin, only: %i[ edit update destroy ]

  def index
    @brands = Brand.all
  end

  def show
    @stores = @brand.stores
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)

    if Brand.exists?(name: @brand.name)
      flash[:alert] = "#{@brand.name}というブランド名はすでに存在します。"
      render :new, status: :unprocessable_entity # Turboに対応
    else
      if @brand.save
        flash[:notice] = "ブランドが作成されました。"
        redirect_to @brand
      else
        render :new, status: :unprocessable_entity # Turboに対応
      end
    end
  end

  def edit
  end

  def update
    if @brand.update(brand_params)
      flash[:notice] = "ブランド情報が更新されました。"
      redirect_to brands_path(@brand)
    else
      render :edit
    end
  end

  def destroy
    @brand.destroy
    flash[:notice] = "ブランドを削除しました"
    redirect_to brands_path
  end

  private

  def set_brand
    @brand = Brand.find_by!(slug: params[:slug])

    if @brand.nil?
      flash[:alert] = "指定されたブランドが見つかりません。"
      redirect_to brands_path
    end
  end

  # 一般管理者のアクセスを禁じる
  def prohibit_access_for_regular_admin
    unless session[:admin_user] == "admin"
      flash[:alert] = "特権管理者のみアクセスが可能です。"
      redirect_to root_path
    end
  end

  def brand_params
    params.require(:brand).permit(:name, :slug)
  end
end
