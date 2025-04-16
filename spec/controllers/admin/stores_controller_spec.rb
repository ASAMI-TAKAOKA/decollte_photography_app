require 'rails_helper'

describe Admin::StoresController, type: :controller do
  let!(:super_admin) { AdminUser.create!(username: "admin", password: "UMtDj4ZBv%&d@Tzh", role: 1) }
  let!(:regular_admin) { AdminUser.create!(username: "regular_admin", password: "password", role: 0) }
  let!(:brand) { Brand.create!(name: "BrandName", slug: "brand-name") }
  let!(:store) { Store.create!(name: "StoreName", address: "StoreAddress", phone_number: "1234567890", brand: brand) }

  describe "GET #index" do
    before { session[:admin_user_id] = super_admin.id }

    it "店舗一覧ページが表示されること" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    before { session[:admin_user_id] = super_admin.id }

    it "店舗詳細ページが表示されること" do
      get :show, params: { brand_id: brand.slug, id: store.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    before { session[:admin_user_id] = super_admin.id }

    it "新規店舗作成ページが表示されること" do
      get :new, params: { brand_id: brand.slug }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    before { session[:admin_user_id] = super_admin.id }

    context "有効なパラメータの場合" do
      it "店舗が作成されること" do
        expect {
          post :create, params: { brand_id: brand.slug, store: { name: "NewStore", address: "NewAddress", phone_number: "9876543210" } }
        }.to change(Store, :count).by(1)
        expect(response).to redirect_to(admin_brand_path(brand))
      end
    end

    context "無効なパラメータの場合" do
      it "店舗が作成されないこと" do
        expect {
          post :create, params: { brand_id: brand.slug, store: { name: "", address: "", phone_number: "" } }
        }.not_to change(Store, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #edit" do
    before { session[:admin_user_id] = super_admin.id }

    it "店舗編集ページが表示されること" do
      get :edit, params: { brand_id: brand.slug, id: store.id }
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    before { session[:admin_user_id] = super_admin.id }

    context "有効なパラメータの場合" do
      it "店舗情報が更新されること" do
        patch :update, params: { brand_id: brand.slug, id: store.id, store: { name: "UpdatedStoreName" } }
        store.reload
        expect(store.name).to eq("UpdatedStoreName")
        expect(response).to redirect_to(admin_brand_path(brand))
      end
    end

    context "無効なパラメータの場合" do
      it "店舗情報が更新されないこと" do
        patch :update, params: { brand_id: brand.slug, id: store.id, store: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    before { session[:admin_user_id] = super_admin.id }

    it "店舗が削除されること" do
      expect {
        delete :destroy, params: { brand_id: brand.slug, id: store.id }
      }.to change(Store, :count).by(-1)
      expect(response).to redirect_to(admin_brand_path(brand))
    end
  end

  describe "regular_adminのアクセス制限" do
    before { session[:admin_user_id] = regular_admin.id }

    it "店舗一覧ページにアクセスできること" do
      get :index
      expect(response).to be_successful
    end

    it "show アクションで管理画面トップにリダイレクトされること" do
      get :show, params: { brand_id: brand.slug, id: store.id }
      expect(response).to redirect_to(admin_root_path)
    end

    it "new アクションで管理画面トップにリダイレクトされること" do
      get :new, params: { brand_id: brand.slug }
      expect(response).to redirect_to(admin_root_path)
    end

    it "create アクションで管理画面トップにリダイレクトされること" do
      post :create, params: { brand_id: brand.slug, store: { name: "NewStore", address: "NewAddress", phone_number: "9876543210" } }
      expect(response).to redirect_to(admin_root_path)
    end

    it "edit アクションで管理画面トップにリダイレクトされること" do
      get :edit, params: { brand_id: brand.slug, id: store.id }
      expect(response).to redirect_to(admin_root_path)
    end

    it "update アクションで管理画面トップにリダイレクトされること" do
      patch :update, params: { brand_id: brand.slug, id: store.id, store: { name: "UpdatedStoreName" } }
      expect(response).to redirect_to(admin_root_path)
    end

    it "destroy アクションで管理画面トップにリダイレクトされること" do
      delete :destroy, params: { brand_id: brand.slug, id: store.id }
      expect(response).to redirect_to(admin_root_path)
    end
  end
end
