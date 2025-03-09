class BrandsController < ApplicationController
  before_action :set_brand, only: %i[show destroy]

  # ブランド一覧
  def index
    @brands = Brand.all
  end

  # ブランド詳細
  def show
  end

  # ブランド作成フォーム
  def new
    @brand = Brand.new
  end

  # ブランドを保存
  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      redirect_to @brand, notice: 'ブランドを作成しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # ブランド削除
  def destroy
    @brand.destroy
    flash[:notice] = 'ブランドを削除しました'
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
