require 'rails_helper'

RSpec.describe AdminUsersController, type: :controller do
  let(:admin_user) { AdminUser.create(username: 'admin', password: 'UMtDj4ZBv%&d@Tzh', role: 1) }

  # シンプルなセッション管理をする方法
  before do
    session[:admin_user] = "admin"  # ログイン処理を手動でシミュレート
  end

  # newアクションのテスト
  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end
  end

  # createアクションのテスト
  describe "POST #create" do
    it "creates a new admin user" do
      expect {
        post :create, params: { admin_user: { username: 'new_admin_user', password: 'password', role: 0 } }
      }.to change(AdminUser, :count).by(1)
      expect(response).to redirect_to(new_admin_user_path)
    end
  end

  # editアクションのテスト
  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { id: admin_user.id }
      expect(response).to be_successful
    end
  end

  # updateアクションのテスト
  describe "PATCH #update" do
    it "updates the admin user" do
      patch :update, params: { id: admin_user.id, admin_user: { username: 'updated_admin' } }
      admin_user.reload
      expect(admin_user.username).to eq('updated_admin')
      expect(response).to redirect_to(edit_admin_user_path(admin_user))
    end
  end

  # destroyアクションのテスト
  describe "DELETE #destroy" do
    it "deletes the admin user" do
      admin_user_to_delete = AdminUser.create(username: 'user_to_delete', password: 'password', role: 0)
      expect {
        delete :destroy, params: { id: admin_user_to_delete.id }
      }.to change(AdminUser, :count).by(-1)
      expect(response).to redirect_to(admin_users_super_admin_dashboard_path)
    end
  end

  # showアクションのテスト
  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: admin_user.id }
      expect(response).to be_successful
    end
  end
end
