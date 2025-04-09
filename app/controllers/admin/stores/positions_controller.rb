class Admin::Stores::PositionsController < Admin::BaseController
  before_action :set_brand, if: -> { params[:brand_id].present? }
  before_action :set_store

  def update
    raise  ActionController::BadRequest.new("Invalid direction: #{direction}") unless %w(move_higher move_lower).include? store_params[:direction]

    @store.send(store_params[:direction])
    redirect_path = @brand ? admin_brand_stores_path(@brand) : admin_stores_path
    redirect_to redirect_path, notice: "店舗の並び順を変更しました"
  end

  private

  def set_brand
    @brand = Brand.find_by!(slug: params[:brand_id]) # idではなくslugでブランドを特定する
  end

  def set_store
    @store = Store.find(params[:store_id])
  end

  def store_params
    params.require(:store).permit(:direction)
  end
end
