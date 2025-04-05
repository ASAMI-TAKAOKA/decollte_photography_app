require 'rails_helper'

RSpec.describe Admin::AdminUsersController, type: :controller do
  let!(:super_admin) { AdminUser.create(username: "admin", password: "UMtDj4ZBv%&d@Tzh", role: 1) }
  let!(:regular_admin) { AdminUser.create(username: "regular_admin", password: "password", role: 0) }

  # 特権管理者(admin)のアクセス
  describe "特権管理者(admin) のアクセス" do
    before do
      # ログインチェックをモックして、trueを返すようにする
      allow(controller).to receive(:check_login).and_return(true)
      # 特権管理者判定をモックして、trueを返すようにする
      allow(controller).to receive(:super_admin?).and_return(true)
      # session[:admin_role] をモックして、1を返すようにする
      allow(controller).to receive(:session).and_return({ admin_role: 1 })
    end

    it "管理者一覧ページにアクセスできること" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "管理者詳細ページにアクセスできること" do
      get :show, params: { id: regular_admin.id }
      expect(response).to have_http_status(:success)
    end

    it "新しい管理者作成ページにアクセスできること" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "新しい管理者を作成できること" do
      expect {
        post :create, params: { admin_user: { username: "new_admin", password: "password" } }
      }.to change(AdminUser, :count).by(1)

      expect(response).to redirect_to(admin_admin_users_path)
      expect(flash[:notice]).to eq("一般管理者を作成しました。")
    end

    it "管理者編集ページにアクセスできること" do
      get :edit, params: { id: regular_admin.id }
      expect(response).to have_http_status(:success)
    end

    it "管理者情報を更新できること" do
      put :update, params: { id: regular_admin.id, admin_user: { username: "updated_admin", password: "new_password" } }
      regular_admin.reload
      expect(regular_admin.username).to eq("updated_admin")
      expect(flash[:notice]).to eq("一般管理者情報を更新しました。")
      expect(response).to redirect_to(admin_admin_users_path)
    end

    it "管理者を削除できること" do
      expect {
        delete :destroy, params: { id: regular_admin.id }
      }.to change(AdminUser, :count).by(-1)

      expect(response).to redirect_to(admin_admin_users_path)
      expect(flash[:notice]).to eq("一般管理者を削除しました。")
    end
  end

  # 一般管理者(regular_admin)のアクセス
  describe "一般管理者(regular_admin) のアクセス" do
    before do
      # ログインチェックをモックして、trueを返すようにする
      allow(controller).to receive(:check_login).and_return(true)
      # 一般管理者判定をモックして、trueを返すようにする
      allow(controller).to receive(:regular_admin?).and_return(true)
      # session[:admin_role] をモックして、0を返すようにする
      allow(controller).to receive(:session).and_return({ admin_role: 0 })
    end

    it "管理者一覧ページにアクセスできないこと" do
      get :index
      expect(response).to redirect_to(admin_root_path)
      expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
    end

    it "管理者詳細ページにアクセスできないこと" do
      get :show, params: { id: super_admin.id }
      expect(response).to redirect_to(admin_root_path)
      expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
    end

    it "新しい管理者作成ページにアクセスできないこと" do
      get :new
      expect(response).to redirect_to(admin_root_path)
      expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
    end

    it "新しい管理者を作成できないこと" do
      expect {
        post :create, params: { admin_user: { username: "fail_admin", password: "password" } }
      }.to_not change(AdminUser, :count)

      expect(response).to redirect_to(admin_root_path)
      expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
    end

    it "管理者編集ページにアクセスできないこと" do
      get :edit, params: { id: regular_admin.id }
      expect(response).to redirect_to(admin_root_path)
      expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
    end

    it "管理者情報を更新できないこと" do
      put :update, params: { id: regular_admin.id, admin_user: { username: "fail_update", password: "fail_password" } }
      regular_admin.reload
      expect(regular_admin.username).not_to eq("fail_update")
      expect(response).to redirect_to(admin_root_path)
      expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
    end

    it "管理者を削除できないこと" do
      expect {
        delete :destroy, params: { id: super_admin.id }
      }.to_not change(AdminUser, :count)

      expect(response).to redirect_to(admin_root_path)
      expect(flash[:alert]).to eq("特権管理者のみアクセスが可能です。")
    end
  end

  # 管理者ユーザーが最後の一人である場合、削除できない
  describe "最後の管理者ユーザー削除制限" do
    before do
      # ログインチェックをモックして、trueを返すようにする
      allow(controller).to receive(:check_login).and_return(true)
      # 特権管理者判定をモックして、trueを返すようにする
      allow(controller).to receive(:super_admin?).and_return(true)
      # session[:admin_role] をモックして、1を返すようにする
      allow(controller).to receive(:session).and_return({ admin_role: 1 })
    end

    it "最後の管理者を削除できないこと" do
      delete :destroy, params: { id: regular_admin.id }
      delete :destroy, params: { id: super_admin.id }
      expect(response).to redirect_to(admin_admin_users_path)
      expect(flash[:alert]).to eq("最後の管理者は削除できません。")
    end
  end
end
