class BrandsController < ApplicationController
  before_action :set_brand, only: %i[ show edit update destroy ]

  # ブランド一覧
  def index
    @brands = Brand.all
  end

  # ブランド詳細
  def show
    @brand = Brand.find(params[:id])
    @stores = @brand.stores
  end

  # ブランド作成フォーム
  def new
    @brand = Brand.new
  end

  # ブランドを保存
  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      redirect_to @brand, notice: "ブランドを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # ブランド編集フォーム
  def edit
  end

  # ブランド更新
  def update
    if @brand.update(brand_params)
      redirect_to brands_path(@brand), notice: "ブランド情報が更新されました。"
    else
      render :edit
    end
  end

  # ブランド削除
  def destroy
    @brand.destroy
    flash[:notice] = "ブランドを削除しました"
    redirect_to brands_path
  end

  private

  def set_brand
    @brand = Brand.find(params[:id])
  end

  def brand_params
    params.require(:brand).permit(:name, :description)
  end
end
