class BrandsController < ApplicationController
  before_action :set_brand, only: %i[ show ]
  def index
    @brands = Brand.order(:created_at)
  end

  def show
    @stores = @brand.stores.order(:position)
  end

  private

  def set_brand
    @brand = Brand.find_by!(slug: params[:id]) # idではなくslugでブランドを特定する
  end
end
