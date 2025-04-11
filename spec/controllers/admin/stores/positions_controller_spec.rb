require 'rails_helper'

RSpec.describe Admin::Stores::PositionsController, type: :controller do
  let!(:super_admin) { AdminUser.create!(username: "admin", password: "UMtDj4ZBv%&d@Tzh", role: 1) }
  let!(:regular_admin) { AdminUser.create!(username: "regular_admin", password: "password", role: 0) }
  let!(:brand) { Brand.create!(name: "ブランド名", slug: "brand-name") }
  let!(:store1) { Store.create!(name: "店舗1", address: "住所1", phone_number: "1234567890", brand: brand, position: 1) }
  let!(:store2) { Store.create!(name: "店舗2", address: "住所2", phone_number: "0987654321", brand: brand, position: 2) }

  describe "特権管理者の場合" do
    before { session[:admin_user_id] = super_admin.id }

    context "ブランドに紐づく店舗を移動する場合" do
      it "店舗を上に移動できる" do
        patch :update, params: { brand_id: brand.id, store_id: store2.id, store: { direction: "move_higher" } }
        expect(response).to redirect_to admin_brand_path(brand)
        expect(store2.reload.position).to eq(1)
        expect(store1.reload.position).to eq(2)
      end

      it "店舗を下に移動できる" do
        patch :update, params: { brand_id: brand.id, store_id: store1.id, store: { direction: "move_lower" } }
        expect(response).to redirect_to admin_brand_path(brand)
        expect(store1.reload.position).to eq(2)
        expect(store2.reload.position).to eq(1)
      end
    end
  end

  describe "一般管理者の場合" do
    before { session[:admin_user_id] = regular_admin.id }

    context "ブランドに紐づく店舗を移動する場合" do
      it "店舗を上に移動できる" do
        patch :update, params: { brand_id: brand.id, store_id: store2.id, store: { direction: "move_higher" } }
        expect(response).to redirect_to admin_brand_path(brand)
        expect(store2.reload.position).to eq(1)
        expect(store1.reload.position).to eq(2)
      end

      it "店舗を下に移動できる" do
        patch :update, params: { brand_id: brand.id, store_id: store1.id, store: { direction: "move_lower" } }
        expect(response).to redirect_to admin_brand_path(brand)
        expect(store1.reload.position).to eq(2)
        expect(store2.reload.position).to eq(1)
      end
    end
  end
end
