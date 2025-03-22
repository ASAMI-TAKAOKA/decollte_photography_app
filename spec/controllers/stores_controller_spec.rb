require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  let!(:super_admin) { AdminUser.create(username: "admin", password: "UMtDj4ZBv%&d@Tzh", role: 1) }
  let!(:regular_admin) { AdminUser.create(username: "regular_admin", password: "password", role: 0) }
  let!(:brand) { Brand.create(name: "TestBrand", slug: "test-brand") }
  let!(:store) { Store.create(name: "TestStore", address: "test-adress", phone_number: "0120-123-456", position: 1, global_position: 1, brand_id: brand.id) }
  let!(:store2) { Store.create(name: "Store2", address: "Address2", phone_number: "0120-654-321", position: 2, global_position: 2, brand_id: brand.id) }

  describe "GET #index" do
    it "店舗一覧ページが正常に表示されること" do
      get :index
      expect(response).to be_successful
      expect(assigns(:stores)).to match_array([ store, store2 ])
    end
  end

  describe "GET #show" do
    context "特権管理者の場合" do
      before do
        session[:admin_user] = super_admin.username # 管理者としてログイン
      end

      it "店舗詳細ページが正常に表示されること" do
        get :show, params: { "brand_slug" => brand.slug, "id" => store.id }
        expect(response).to be_successful
        expect(assigns(:brand)).to eq(brand)
        expect(assigns(:store)).to eq(store)
      end
    end

    context "一般管理者の場合" do
      before do
        session[:admin_user] = regular_admin.username # 一般管理者としてログイン
      end

      it "店舗詳細ページにアクセスできないこと" do
        get :show, params: { "brand_slug" => brand.slug, "id" => store.id }
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #new" do
    context "特権管理者の場合" do
      before do
        session[:admin_user] = super_admin.username # 管理者としてログイン
      end

      it "店舗作成ページが正常に表示されること" do
        get :new, params: { "brand_slug" => brand.slug }
        expect(response).to be_successful
      end
    end

    context "一般管理者の場合" do
      before do
        session[:admin_user] = regular_admin.username # 一般管理者としてログイン
      end

      it "店舗作成ページにアクセスできないこと" do
        get :new, params: { "brand_slug" => brand.slug }
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #create" do
    context "特権管理者の場合" do
      context "正常な場合" do
        before do
          session[:admin_user] = super_admin.username # 管理者としてログイン
        end

        it "店舗が作成されること" do
          post :create, params: { "store" => { "name" => "New Store", "address" => "千葉県習志野市", "phone_number" => "0120-456-789" }, "brand_slug" => brand.slug }
          expect(flash[:notice]).to eq("店舗が作成されました。")
          expect(response).to redirect_to(brand_path(brand))
        end
      end

      context "不正なパラメータの場合" do
        before do
          session[:admin_user] = super_admin.username # 管理者としてログイン
        end

        it "店舗が作成されないこと" do
          post :create, params: { "store" => { "name" => "", "address" => "", "phone_number" => "" }, "brand_slug" => brand.slug }
          expect(response).to render_template(:new)
          expect(assigns(:store).errors).to be_present
        end
      end
    end

    context "一般管理者の場合" do
      before do
        session[:admin_user] = regular_admin.username # 一般管理者としてログイン
      end

      it "店舗作成ページにアクセスできないこと" do
        get :new, params: { "brand_slug" => brand.slug }
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #edit" do
    context "特権管理者の場合" do
      before do
        session[:admin_user] = super_admin.username # 管理者としてログイン
      end

      it "店舗編集ページが表示されること" do
        get :edit, params: { "brand_slug" => brand.slug, "id" => store.id }
        expect(response).to be_successful
      end
    end

    context "一般管理者の場合" do
      before do
        session[:admin_user] = regular_admin.username # 一般管理者としてログイン
      end

      it "店舗編集ページにアクセスできないこと" do
        get :edit, params: { "brand_slug" => brand.slug, "id" => store.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH #update" do
    context "特権管理者の場合" do
      before do
        session[:admin_user] = super_admin.username # 管理者としてログイン
      end

      it "店舗情報が更新されること" do
        patch :update, params: { "store" => { "name" => "Updated Store", "address" => "Updated Address", "phone_number" => "0120999888" }, "brand_slug" => brand.slug, "id" => store.id }
        expect(store.reload.name).to eq("Updated Store")
        expect(response).to redirect_to(brand_store_path(brand, store))
        expect(flash[:notice]).to eq("店舗情報が更新されました。")
      end
    end

    context "一般管理者の場合" do
      before do
        session[:admin_user] = regular_admin.username # 一般管理者としてログイン
      end

      it "店舗更新ページにアクセスできないこと" do
        patch :update, params: { "store" => { "name" => "Updated Store", "address" => "Updated Address", "phone_number" => "0120999888" }, "brand_slug" => brand.slug, "id" => store.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "特権管理者の場合" do
      before do
        session[:admin_user] = super_admin.username # 管理者としてログイン
      end

      it "店舗が削除されること" do
        delete :destroy, params: { "brand_slug" => brand.slug, "id" => store.id }
        expect(Store.exists?(store.id)).to be_falsey
        expect(response).to redirect_to(brand_path(brand))
        expect(flash[:notice]).to eq("店舗が削除されました。")
      end
    end

    context "一般管理者の場合" do
      before do
        session[:admin_user] = regular_admin.username # 一般管理者としてログイン
      end

      it "店舗削除ページにアクセスできないこと" do
        delete :destroy, params: { "brand_slug" => brand.slug, "id" => store.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH #move_higher_global" do
    before do
      session[:admin_user] = super_admin.username # 管理者としてログイン
    end

    it "storeがglobal_positionで上に移動すること" do
      patch :move_higher_global, params: { "id" => store2.id, "brand_slug" => brand.slug }
      store2.reload
      expect(store2.global_position).to eq(1)
      store.reload
      expect(store.global_position).to eq(2)
    end
  end

  describe "PATCH #move_lower_global" do
    before do
      session[:admin_user] = super_admin.username # 管理者としてログイン
    end

    it "storeがglobal_positionで下に移動すること" do
      patch :move_lower_global, params: { "id" => store.id, "brand_slug" => brand.slug }
      store.reload
      expect(store.global_position).to eq(2)
      store2.reload
      expect(store2.global_position).to eq(1)
    end
  end

  describe "PATCH #move_higher_within_brand" do
    before do
      session[:admin_user] = super_admin.username # 管理者としてログイン
    end

    it "storeがbrand内でpositionで上に移動すること" do
      patch :move_higher_within_brand, params: { "id" => store2.id, "brand_slug" => brand.slug }
      store2.reload
      expect(store2.position).to eq(1)
      store.reload
      expect(store.position).to eq(2)
    end
  end

  describe "PATCH #move_lower_within_brand" do
    before do
      session[:admin_user] = super_admin.username # 管理者としてログイン
    end

    it "storeがbrand内でpositionで下に移動すること" do
      patch :move_lower_within_brand, params: { "id" => store.id, "brand_slug" => brand.slug }
      store.reload
      expect(store.position).to eq(2)
      store2.reload
      expect(store2.position).to eq(1)
    end
  end
end
