require 'rails_helper'

RSpec.describe Admin::BrandsController, type: :controller do
  let!(:brand) { Brand.create(name: "TestBrand", slug: "test-brand") }

  before do
    # ログインチェックをモックして、trueを返すようにする
    allow(controller).to receive(:check_login).and_return(true)
  end

  describe "GET #index" do
    it "ブランド一覧ページが正常に表示されること" do
      get :index
      expect(response).to be_successful
      expect(assigns(:brands)).to eq([ brand ])
    end
  end

  describe "GET #show" do
    it "ブランド詳細ページが正常に表示されること" do
      get :show, params: { id: brand.slug }
      expect(response).to be_successful
      expect(assigns(:brand)).to eq(brand)
      expect(assigns(:stores)).to eq(brand.stores)
    end
  end

  describe "GET #new" do
    it "新しいブランド作成ページが正常に表示されること" do
      get :new
      expect(response).to be_successful
      expect(assigns(:brand)).to be_a_new(Brand)
    end
  end

  describe "POST #create" do
    context "正常な場合" do
      it "ブランドが作成されること" do
        expect {
          post :create, params: { brand: { name: "NewBrand", slug: "new-brand" } }
        }.to change(Brand, :count).by(1)
        expect(response).to redirect_to(admin_brands_path)
        expect(flash[:notice]).to eq("ブランドを作成しました。")
      end
    end

    context "不正なパラメータの場合" do
      it "ブランドが作成されないこと" do
        post :create, params: { brand: { name: "", slug: "" } }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
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

      it "ブランド編集ページが表示されること" do
        get :edit, params: { id: brand.slug }
        expect(response).to be_successful
        expect(assigns(:brand)).to eq(brand)
      end
    end

    context "一般管理者の場合" do
      before do
        # 一般管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:regular_admin?).and_return(true)
        # session[:admin_role] をモックして、0を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 0 })
      end

      it "ブランド編集ページにアクセスできないこと" do
        get :edit, params: { id: brand.slug }
        expect(response).to redirect_to(admin_root_path) # 管理者ページにリダイレクトされる
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

      it "ブランド名が更新されること" do
        patch :update, params: { id: brand.slug, brand: { name: "UpdatedBrandName" } }
        expect(response).to redirect_to(admin_brands_path)
        expect(flash[:notice]).to eq("ブランド情報が更新されました。")
        brand.reload
        expect(brand.name).to eq("UpdatedBrandName")
      end

      it "slugは更新されないこと" do
        patch :update, params: { id: brand.slug, brand: { name: "UpdatedBrandName", slug: "UpdatedBrandSlug" } }

        brand.reload
        expect(brand.name).not_to eq("UpdatedBrandName")
        expect(brand.slug).to eq("test-brand")
        expect(assigns(:brand).errors[:slug]).to include("は変更できません")
      end
    end

    context "一般管理者の場合" do
      before do
        # 一般管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:regular_admin?).and_return(true)
        # session[:admin_role] をモックして、0を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 0 })
      end

      it "ブランド更新ページにアクセスできないこと" do
        patch :update, params: { id: brand.slug, brand: { name: "UpdatedBrand" } }
        expect(response).to redirect_to(admin_root_path) # 管理者ページにリダイレクトされる
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

      it "ブランドが削除されること" do
        expect {
          delete :destroy, params: { id: brand.slug }
        }.to change(Brand, :count).by(-1)
        expect(response).to redirect_to(admin_brands_path)
        expect(flash[:notice]).to eq("ブランドを削除しました")
      end
    end

    context "一般管理者の場合" do
      before do
        # 一般管理者判定をモックして、trueを返すようにする
        allow(controller).to receive(:regular_admin?).and_return(true)
        # session[:admin_role] をモックして、0を返すようにする
        allow(controller).to receive(:session).and_return({ admin_role: 0 })
      end

      it "ブランド削除ページにアクセスできないこと" do
        delete :destroy, params: { id: brand.slug }
        expect(response).to redirect_to(admin_root_path) # 管理者ページにリダイレクトされる
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
      end
    end
  end
end
