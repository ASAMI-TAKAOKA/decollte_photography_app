require 'rails_helper'

RSpec.describe AdminUsersController, type: :controller do
  let!(:super_admin) { AdminUser.create(username: "admin", password: "UMtDj4ZBv%&d@Tzh", role: 1) }
  let!(:regular_admin) { AdminUser.create(username: "regular_admin", password: "password", role: 0) }

  describe "特権管理者(admin) のアクセス" do
    before do
      session[:admin_user] = "admin" # 特権管理者としてログイン
    end

    it "ダッシュボードにアクセスできること" do
      get :dashboard
      expect(response).to have_http_status(:success)
    end

    it "管理者一覧ページにアクセスできること" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "新しい管理者を作成できること" do
      expect {
        post :create, params: { admin_user: { username: "new_admin", password: "password", role: 0 } }
      }.to change(AdminUser, :count).by(1)

      expect(response).to redirect_to(new_admin_user_path)
      expect(flash[:notice]).to eq("Admin user created successfully")
    end

    it "管理者情報を更新できること" do
      put :update, params: { id: regular_admin.id, admin_user: { username: "updated_admin", password: "new_password" } }
      regular_admin.reload
      expect(regular_admin.username).to eq("updated_admin")
      expect(flash[:notice]).to eq("Admin user updated successfully")
      expect(response).to redirect_to(edit_admin_user_path)
    end

    it "管理者を削除できること" do
      expect {
        delete :destroy, params: { id: regular_admin.id }
      }.to change(AdminUser, :count).by(-1)

      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq("Admin user destroyed successfully")
    end
  end

  describe "一般管理者(regular_admin) のアクセス" do
    before do
      session[:admin_user] = "regular_admin" # 一般管理者としてログイン
    end

    it "ダッシュボードにアクセスできること" do
      get :dashboard
      expect(response).to have_http_status(:success)
    end

    it "管理者一覧ページにアクセスできないこと" do
      get :index
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
    end

    it "新しい管理者を作成できないこと" do
      expect {
        post :create, params: { admin_user: { username: "fail_admin", password: "password", role: 0 } }
      }.to_not change(AdminUser, :count)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
    end

    it "管理者情報を更新できないこと" do
      put :update, params: { id: regular_admin.id, admin_user: { username: "fail_update", password: "fail_password" } }
      regular_admin.reload
      expect(regular_admin.username).not_to eq("fail_update")
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
    end

    it "管理者を削除できないこと" do
      expect {
        delete :destroy, params: { id: super_admin.id }
      }.to_not change(AdminUser, :count)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
    end
  end

  describe "ログイン機能" do
    it "正しい情報でログインできること" do
      post :login, params: { username: "admin", password: "UMtDj4ZBv%&d@Tzh" }
      expect(session[:admin_user]).to eq("admin")
      expect(flash[:notice]).to eq("ログインしました。")
      expect(response).to redirect_to(admin_dashboard_path)
    end

    # TODO: コードを要修正
    # it "間違った情報（未登録のユーザー情報）でログインできないこと" do
    #   post :login, params: { username: "testuser", password: "wrongpassword" }
    #   expect(session[:admin_user]).to eq("regular_admin")
    #   expect(flash[:alert]).to eq("ログイン情報が正しくありません。")
    #   expect(response).to redirect_to(admin_users_login_path)
    # end
  end

  describe "ログアウト機能" do
    before do
      session[:admin_user] = "admin" # ログイン状態
    end

    it "ログアウトできること" do
      post :logout
      expect(session[:admin_user]).to be_nil
      expect(flash[:notice]).to eq("ログアウトしました。")
      expect(response).to redirect_to(admin_users_login_path)
    end
  end
end
