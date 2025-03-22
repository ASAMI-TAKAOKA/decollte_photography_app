require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  let!(:super_admin) { AdminUser.create(username: "admin", password: "UMtDj4ZBv%&d@Tzh", role: 1) }
  let!(:regular_admin) { AdminUser.create(username: "regular_admin", password: "password", role: 0) }
  let!(:brand) { Brand.create(name: "TestBrand", slug: "test-brand") }
  let!(:store1) { Store.create(name: "Test Store1", address: "123 Test St2", phone_number: "0120-111-222", position: 1, brand_id: brand.id) }
  let!(:store2) { Store.create(name: "Test Store2", address: "123 Test St2", phone_number: "0120-333-444", position: 2, brand_id: brand.id) }

  describe '特権管理者(admin) のアクセス' do
    before do
      session[:admin_user] = "admin" # 特権管理者としてログイン
    end

    it '店舗一覧ページにアクセスできること' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it '店舗詳細ページにアクセスできること' do
      get :show, params: { brand_slug: "test-brand", id: store1.id }
      expect(response).to have_http_status(:success)
    end

    it '新しい店舗を作成できること' do
      post :create, params: { store: { name: "New Store", address: "千葉県流山市3-3-5", phone_number: "0120666666" }, "brand_slug" => "test-brand" }
      expect(response).to redirect_to(brand_path(brand.slug))
      expect(Store.count).to eq(3)
    end

    it '店舗情報を更新できること' do
      patch :update, params: { store: { name: "Updated Store", address: "大阪府大阪市3-7-6-104", phone_number: "08012345678" }, brand_slug: "test-brand", id: store1.id }
      expect(store1.reload.name).to eq("Updated Store")
      expect(response).to redirect_to(brand_store_path(brand.slug, store1.id))
    end

    it '店舗を削除できること' do
      delete :destroy, params: { brand_slug: "test-brand", id: store1.id }
      expect(Store.count).to eq(1)
      expect(response).to redirect_to(brand_path(brand.slug))
    end
  end

  describe '一般管理者(regular_admin) のアクセス' do
    before do
      session[:admin_user] = "regular_admin" # 一般管理者としてログイン
    end

    it '店舗一覧ページにアクセスできること' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it '店舗詳細ページにアクセスできないこと' do
      get :show, params: { brand_slug: "test-brand", id: store1.id }
      expect(response).to redirect_to(root_path)
    end

    it '新しい店舗を作成できないこと' do
      post :create, params: { store: { name: "New Store", address: "千葉県流山市3-3-5", phone_number: "0120666666" }, brand_slug: "test-brand" }
      expect(response).to redirect_to(root_path)
    end

    it '店舗情報を更新できないこと' do
      patch :update, params: { store: { name: "Updated Store", address: "大阪府大阪市3-7-6-104", phone_number: "08012345678" }, brand_slug: "test-brand", id: store2.id }
      expect(store2.reload.name).to eq("Test Store2")
      expect(response).to redirect_to(root_path)
    end

    it '店舗を削除できないこと' do
      delete :destroy, params: { brand_slug: "test-brand", id: store2.id }
      expect(Store.count).to eq(2)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '特権管理者(admin) の並び順変更' do
    before do
      session[:admin_user] = "admin"
    end

    it '店舗を上に移動できること' do
      get :move_higher_within_brand, params: { brand_slug: brand.slug, id: store2.id }
      expect(response).to redirect_to(brand_stores_path)
      expect(store2.reload.position).to eq(1)
      expect(store1.reload.position).to eq(2)
    end

    it '店舗を下に移動できること' do
      get :move_lower_within_brand, params: { brand_slug: brand.slug, id: store1.id }
      expect(response).to redirect_to(brand_stores_path)
      expect(store1.reload.position).to eq(2)
      expect(store2.reload.position).to eq(1)
    end
  end

  describe '一般管理者(regular_admin) の並び順変更' do
    before do
      session[:admin_user] = "regular_admin"
    end

    it '店舗を上に移動できること' do
      get :move_higher_within_brand, params: { brand_slug: brand.slug, id: store2.id }
      expect(response).to redirect_to(brand_stores_path)
      expect(store2.reload.position).to eq(1)
      expect(store1.reload.position).to eq(2)
    end

    it '店舗を下に移動できること' do
      get :move_lower_within_brand, params: { brand_slug: brand.slug, id: store1.id }
      expect(response).to redirect_to(brand_stores_path)
      expect(store1.reload.position).to eq(2)
      expect(store2.reload.position).to eq(1)
    end
  end
end
