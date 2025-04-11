require 'rails_helper'

describe Admin::BrandsController, type: :controller do
  let!(:super_admin) { AdminUser.create!(username: "admin", password: "UMtDj4ZBv%&d@Tzh", role: 1) }
  let!(:regular_admin) { AdminUser.create!(username: "regular_admin", password: "password", role: 0) }
  let!(:brand) { Brand.create!(name: "BrandName", slug: "brand-name") }

  describe "GET #index" do
    before { session[:admin_user_id] = super_admin.id }

    it "ブランド一覧ページが表示されること" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    before { session[:admin_user_id] = super_admin.id }

    it "ブランド詳細ページが表示されること" do
      get :show, params: { id: brand.slug }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    before { session[:admin_user_id] = super_admin.id }

    it "新規ブランド作成ページが表示されること" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    before { session[:admin_user_id] = super_admin.id }

    context "有効なパラメータの場合" do
      it "ブランドが作成され、ブランド一覧にリダイレクトされること" do
        expect {
          post :create, params: { brand: { name: "NewBrand", slug: "new-brand" } }
        }.to change(Brand, :count).by(1)

        expect(response).to redirect_to(admin_brands_path)
      end
    end

    context "無効なパラメータの場合" do
      it "ブランド作成ページを再表示すること" do
        post :create, params: { brand: { name: "", slug: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #edit" do
    context "super_admin の場合" do
      before { session[:admin_user_id] = super_admin.id }

      it "ブランド編集ページが表示されること" do
        get :edit, params: { id: brand.slug }
        expect(response).to be_successful
      end
    end

    context "regular_admin の場合" do
      before { session[:admin_user_id] = regular_admin.id }

      it "管理者トップページにリダイレクトされること" do
        get :edit, params: { id: brand.slug }
        expect(response).to redirect_to(admin_root_path)
      end
    end
  end

  describe "PATCH #update" do
    context "super_admin の場合" do
      before { session[:admin_user_id] = super_admin.id }

      it "ブランド名が更新され、ブランド一覧にリダイレクトされること" do
        patch :update, params: { id: brand.slug, brand: { name: "UpdatedBrandName" } }
        brand.reload
        expect(brand.name).to eq("UpdatedBrandName")
        expect(response).to redirect_to(admin_brands_path)
      end
    end

    context "regular_admin の場合" do
      before { session[:admin_user_id] = regular_admin.id }

      it "ブランドは更新されず、管理者トップページにリダイレクトされること" do
        patch :update, params: { id: brand.slug, brand: { name: "UpdatedBrandName" } }
        brand.reload
        expect(brand.name).to eq("BrandName")
        expect(response).to redirect_to(admin_root_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "super_admin の場合" do
      before { session[:admin_user_id] = super_admin.id }

      it "ブランドが削除され、ブランド一覧にリダイレクトされること" do
        delete :destroy, params: { id: brand.slug }
        expect(response).to redirect_to(admin_brands_path)
        expect(Brand.exists?(brand.id)).to be_falsey
      end
    end

    context "regular_admin の場合" do
      before { session[:admin_user_id] = regular_admin.id }

      it "ブランドは削除されず、管理者トップページにリダイレクトされること" do
        delete :destroy, params: { id: brand.slug }
        expect(response).to redirect_to(admin_root_path)
        expect(Brand.exists?(brand.id)).to be_truthy
      end
    end
  end
end
