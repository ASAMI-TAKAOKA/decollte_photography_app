class Admin::BrandsController < ApplicationController
  before_action :authenticate_admin_user
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
      render :edit
    end
  end

  def destroy
    @brand.destroy
    redirect_to admin_brands_path, notice: "ブランドを削除しました"
  end

  private

  def set_brand
    @brand = Brand.find_by(slug: params[:slug])
  end

  # 一般管理者のアクセスを禁じる
  def prohibit_access_for_regular_admin
    unless session[:admin_role] == 1
      redirect_to admin_dashboards_path, alert: "特権管理者のみアクセスが可能です。"
    end
  end

  def brand_params
    if action_name == "update"

      params.require(:brand).permit(:name) # slug を除外（仕様に「ブランド作成後のパスの変更は不可」 と記載があったため、updateアクションでslugを更新できないようにしています。）
    else
      params.require(:brand).permit(:name, :slug)
    end
  end

  # session[:admin_role] の値が 0 または 1 の場合のみログインを許可する
  def authenticate_admin_user
    unless session[:admin_role].in?([ 0, 1 ])
      redirect_to new_admin_session_path, alert: "ログインが必要です。"
    end
  end
end
