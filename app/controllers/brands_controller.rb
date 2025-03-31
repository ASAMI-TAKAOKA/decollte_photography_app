class BrandsController < ApplicationController
  before_action :set_brand, only: %i[ show ]
  def index
    @brands = Brand.all
  end

  def show
    @stores = @brand.stores
  end

  private

  def set_brand
    @brand = Brand.find_by(slug: params[:slug])
  end
end
