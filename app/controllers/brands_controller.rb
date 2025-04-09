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
    @brand = Brand.friendly.find(params[:id])
  end
end
