class StoresController < ApplicationController
  def index
    @stores = Store.order(:position)
  end
end
