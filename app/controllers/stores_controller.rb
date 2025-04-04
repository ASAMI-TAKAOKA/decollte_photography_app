class StoresController < ApplicationController
  def index
    @stores = Store.order(:position)
  end

  def show
    @store = Store.find(params[:id])
  end
end
