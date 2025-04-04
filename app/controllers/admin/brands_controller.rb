class Admin::BrandsController < ApplicationController
  before_action :check_login
  before_action :set_brand, only: %i[ show edit update destroy ]
  before_action :prohibit_access_for_regular_admin, only: %i[ edit update destroy ]

  def index
    @brands = Brand.order(:created_at)
  end

  def show
    @stores = @brand.stores.order(:position)
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)

    if @brand.save
      redirect_to admin_brands_path, notice: "ブランドを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @brand.update(brand_params)
      redirect_to admin_brands_path, notice: "ブランド情報が更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @brand.destroy
    redirect_to admin_brands_path, notice: "ブランドを削除しました"
  end

  private

  def set_brand
    @brand = Brand.find_by!(slug: params[:id]) # idではなくslugでブランドを特定する
  end

  # 一般管理者のアクセスを禁じる
  def prohibit_access_for_regular_admin
    unless session[:admin_role] == 1
      redirect_to admin_dashboards_path, alert: "特権管理者のみアクセスが可能です。"
    end
  end

  def brand_params
    params.require(:brand).permit(:name, :slug)
  end
end
