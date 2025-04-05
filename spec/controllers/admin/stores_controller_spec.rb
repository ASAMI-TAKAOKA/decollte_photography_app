require 'rails_helper'

RSpec.describe Admin::StoresController, type: :controller do
  let!(:brand) { Brand.create(name: "TestBrand", slug: "test-brand") }
  let!(:store) { brand.stores.create(name: "TestStore", address: "Test Address", phone_number: "1234567890", position: 1) }

  before do
    # ログインチェックをモックして、trueを返すようにする
    allow(controller).to receive(:check_login).and_return(true)
  end

  describe "GET #index" do
    it "店舗一覧ページが正常に表示されること" do
      get :index
      expect(response).to be_successful
      expect(assigns(:grouped_stores)).to eq({ brand => [ store ] })
    end
  end

  describe "GET #show" do
    context "特権管理者の場合" do
      before do
        # 特権管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:super_admin?).and_return(true)
        # session[:admin_role] をモックして、1を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 1 })
      end

      it "店舗詳細ページが表示されること" do
        get :show, params: { brand_id: brand.slug, id: store.id }
        expect(response).to be_successful
        expect(assigns(:store)).to eq(store)
      end
    end

    context "一般管理者の場合" do
      before do
        # 一般管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:regular_admin?).and_return(true)
        # session[:admin_role] をモックして、0を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 0 })
      end

      it "店舗詳細ページにアクセスできないこと" do
        get :show, params: { brand_id: brand.slug, id: store.id }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
      end
    end
  end

  describe "GET #new" do
    context "特権管理者の場合" do
      before do
        # 特権管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:super_admin?).and_return(true)
        # session[:admin_role] をモックして、1を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 1 })
      end

      it "店舗作成ページが表示されること" do
        get :new, params: { brand_id: brand.slug }
        expect(response).to be_successful
        expect(assigns(:store)).to be_a_new(Store)
      end
    end

    context "一般管理者の場合" do
      before do
        # 一般管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:regular_admin?).and_return(true)
        # session[:admin_role] をモックして、0を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 0 })
      end

      it "店舗作成ページにアクセスできないこと" do
        get :new, params: { brand_id: brand.slug }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
      end
    end
  end

  describe "POST #create" do
    context "特権管理者の場合" do
      before do
        # 特権管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:super_admin?).and_return(true)
        # session[:admin_role] をモックして、1を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 1 })
      end

      context "正常な場合" do
        it "店舗が作成されること" do
          post :create, params: { store: { name: "New Store", address: "千葉県習志野市", phone_number: "0120-456-789", position: 2 }, brand_id: brand.slug }
          expect(flash[:notice]).to eq("店舗が作成されました。")
          expect(response).to redirect_to(admin_brand_path(brand))
        end
      end

      context "不正なパラメータの場合" do
        it "店舗が作成されないこと" do
          post :create, params: { store: { name: "", address: "", phone_number: "", position: 1 }, brand_id: brand.slug }
          expect(response).to render_template(:new)
          expect(assigns(:store).errors).to be_present
        end
      end

      context "店舗名が既に存在する場合" do
        it "店舗作成が失敗しエラーメッセージが表示されること" do
          post :create, params: { store: { name: store.name, address: "New Address", phone_number: "0987654321", position: 2 }, brand_id: brand.slug }
          expect(response).to render_template(:new)
          expect(store.name).to eq("TestStore")
        end
      end
    end

    context "一般管理者の場合" do
      before do
        # 一般管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:regular_admin?).and_return(true)
        # session[:admin_role] をモックして、0を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 0 })
      end

      it "店舗作成ページにアクセスできないこと" do
        get :new, params: { brand_id: brand.slug }
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
        expect(response).to redirect_to(admin_root_path)
      end
    end
  end

  describe "GET #edit" do
    context "特権管理者の場合" do
      before do
        # 特権管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:super_admin?).and_return(true)
        # session[:admin_role] をモックして、1を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 1 })
      end

      it "店舗編集ページが表示されること" do
        get :edit, params: { brand_id: brand.slug, id: store.id }
        expect(response).to be_successful
        expect(assigns(:store)).to eq(store)
      end
    end

    context "一般管理者の場合" do
      before do
        # 一般管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:regular_admin?).and_return(true)
        # session[:admin_role] をモックして、0を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 0 })
      end

      it "店舗編集ページにアクセスできないこと" do
        get :edit, params: { brand_id: brand.slug, id: store.id }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
      end
    end
  end

  describe "PATCH #update" do
    context "特権管理者の場合" do
      before do
        # 特権管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:super_admin?).and_return(true)
        # session[:admin_role] をモックして、1を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 1 })
      end

      it "店舗情報が更新されること" do
        patch :update, params: { brand_id: brand.slug, id: store.id, store: { name: "UpdatedStoreName", address: "Updated Address", phone_number: "0987654321", position: 1 } }
        expect(response).to redirect_to(admin_brand_path(brand))
        expect(flash[:notice]).to eq("店舗情報が更新されました。")
        store.reload
        expect(store.name).to eq("UpdatedStoreName")
      end

      it "店舗順番の変更が行われること (higher)" do
        patch :update, params: { brand_id: brand.slug, id: store.id, store: { direction: "higher", scope_type: "brand", position: 1 } }
        expect(response).to redirect_to(admin_brand_path(brand))
        expect(flash[:notice]).to eq("店舗の順番を変更しました。")
      end

      it "店舗順番の変更が行われること (lower)" do
        patch :update, params: { brand_id: brand.slug, id: store.id, store: { direction: "lower", scope_type: "brand", position: 1 } }
        expect(response).to redirect_to(admin_brand_path(brand))
        expect(flash[:notice]).to eq("店舗の順番を変更しました。")
      end

      it "scope_type が all の場合、リダイレクト先が店舗一覧ページであること" do
        patch :update, params: { brand_id: brand.slug, id: store.id, store: { direction: "higher", scope_type: "all", position: 1 } }
        expect(response).to redirect_to(admin_stores_path)
        expect(flash[:notice]).to eq("店舗の順番を変更しました。")
      end
    end

    context "一般管理者の場合" do
      before do
        # 一般管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:regular_admin?).and_return(true)
        # session[:admin_role] をモックして、0を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 0 })
      end

      it "店舗情報更新ページにアクセスできないこと" do
        patch :update, params: { brand_id: brand.slug, id: store.id, store: { name: "UpdatedStoreName" } }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
      end
    end
  end

  describe "DELETE #destroy" do
    context "特権管理者の場合" do
      before do
        # 特権管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:super_admin?).and_return(true)
        # session[:admin_role] をモックして、1を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 1 })
      end

      it "店舗が削除されること" do
        expect {
          delete :destroy, params: { brand_id: brand.slug, id: store.id }
        }.to change(Store, :count).by(-1)
        expect(response).to redirect_to(admin_brand_path(brand))
        expect(flash[:notice]).to eq("店舗が削除されました。")
      end
    end

    context "一般管理者の場合" do
      before do
        # 一般管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:regular_admin?).and_return(true)
        # session[:admin_role] をモックして、0を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 0 })
      end

      it "店舗削除ページにアクセスできないこと" do
        delete :destroy, params: { brand_id: brand.slug, id: store.id }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
      end
    end
  end
end
