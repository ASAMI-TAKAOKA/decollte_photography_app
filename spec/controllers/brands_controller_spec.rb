require 'rails_helper'

RSpec.describe BrandsController, type: :controller do
  let!(:super_admin) { AdminUser.create(username: "admin", password: "UMtDj4ZBv%&d@Tzh", role: 1) }
  let!(:regular_admin) { AdminUser.create(username: "regular_admin", password: "password", role: 0) }
  let!(:brand) { Brand.create(name: "TestBrand", slug: "test-brand") }

  describe "GET #index" do
    it "ブランド一覧ページが正常に表示されること" do
      get :index
      expect(response).to be_successful
      expect(assigns(:brands)).to eq([ brand ])
    end
  end

  describe "GET #show" do
    it "ブランド詳細ページが正常に表示されること" do
      get :show, params: { slug: brand.slug }
      expect(response).to be_successful
      expect(assigns(:brand)).to eq(brand)
      expect(assigns(:stores)).to eq(brand.stores)
    end

    # TODO: コード要修正
    # it "存在しないブランドにアクセスした場合、エラーメッセージが表示されること" do
    #   get :show, params: { slug: "non-existing-slug" }
    #   expect(flash[:alert]).to eq("指定されたブランドが見つかりません。")
    #   expect(response).to redirect_to(brands_path)
    # end
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
        post :create, params: { brand: { name: "NewBrand", slug: "new-brand" } }
        expect(flash[:notice]).to eq("ブランドが作成されました。")
        expect(response).to redirect_to(brand_path(assigns(:brand)))
      end
    end

    context "ブランド名が重複している場合" do
      it "エラーメッセージが表示されること" do
        post :create, params: { brand: { name: brand.name, slug: "duplicate-brand" } }
        expect(flash[:alert]).to eq("#{brand.name}というブランド名はすでに存在します。")
        expect(response).to render_template(:new)
      end
    end

    context "不正なパラメータの場合" do
      it "ブランドが作成されないこと" do
        post :create, params: { brand: { name: "", slug: "" } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    context "特権管理者の場合" do
      before do
        session[:admin_user] = super_admin.username # 管理者としてログイン
      end

      it "ブランド編集ページが表示されること" do
        get :edit, params: { slug: brand.slug }
        expect(response).to be_successful
        expect(assigns(:brand)).to eq(brand)
      end
    end

    context "一般管理者の場合" do
      before do
        session[:admin_user] = regular_admin.username # 一般管理者としてログイン
      end

      it "ブランド編集ページにアクセスできないこと" do
        get :edit, params: { slug: brand.slug }
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH #update" do
    context "特権管理者の場合" do
      before do
        session[:admin_user] = super_admin.username # 管理者としてログイン
      end

      # TODO: コード要修正: slugは更新できたらだめ
      # it "ブランド情報が更新されること" do
      #   patch :update, params: { slug: brand.slug, brand: { name: "UpdatedBrand" } }
      #   expect(flash[:notice]).to eq("ブランド情報が更新されました。")
      #   expect(response).to redirect_to(brands_path)
      #   brand.reload
      #   expect(brand.name).to eq("UpdatedBrand")
      # end
    end

    context "一般管理者の場合" do
      before do
        session[:admin_user] = regular_admin.username # 一般管理者としてログイン
      end

      it "ブランド更新ページにアクセスできないこと" do
        patch :update, params: { slug: brand.slug, brand: { name: "UpdatedBrand", slug: "updated-brand" } }
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "特権管理者の場合" do
      before do
        session[:admin_user] = super_admin.username # 管理者としてログイン
      end

      it "ブランドが削除されること" do
        delete :destroy, params: { slug: brand.slug }
        expect(flash[:notice]).to eq("ブランドを削除しました")
        expect(response).to redirect_to(brands_path)
        expect(Brand.exists?(brand.id)).to be_falsey
      end
    end

    context "一般管理者の場合" do
      before do
        session[:admin_user] = regular_admin.username # 一般管理者としてログイン
      end

      it "ブランド削除ページにアクセスできないこと" do
        delete :destroy, params: { slug: brand.slug }
        expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
