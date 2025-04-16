require 'rails_helper'

RSpec.describe Admin::DashboardsController, type: :controller do
  let!(:super_admin) { AdminUser.create!(username: "admin", password: "UMtDj4ZBv%&d@Tzh", role: 1) }
  let!(:regular_admin) { AdminUser.create!(username: "regular_admin", password: "password", role: 0) }

  describe "ログインチェック" do
    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトされる" do
        get :show
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context "ログインしている場合" do
      before do
        session[:admin_user_id] = super_admin.id
      end

      it "アクセスできること" do
        get :show
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "一般管理者アクセス" do
    before do
      session[:admin_user_id] = regular_admin.id
    end

    it "アクセスできること（制限なし）" do
      get :show
      expect(response).to have_http_status(:ok)
    end
  end
end
