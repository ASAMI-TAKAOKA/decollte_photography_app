require 'rails_helper'

RSpec.describe Admin::DashboardsController, type: :controller do
  let!(:super_admin) { AdminUser.create!(username: "admin", password: "password", role: 1) }
  let!(:regular_admin) { AdminUser.create!(username: "regular_admin", password: "password", role: 0) }

  describe "GET #show" do
    context "認証済みの管理者の場合" do
      it "特権管理者 (role: 1) はダッシュボードを表示できること" do
        session[:admin_user_id] = super_admin.id
        session[:admin_role] = 1

        get :show
        expect(response).to have_http_status(:success)
      end

      it "一般管理者 (role: 0) はダッシュボードを表示できること" do
        session[:admin_user_id] = regular_admin.id
        session[:admin_role] = 0

        get :show
        expect(response).to have_http_status(:success)
      end
    end

    context "未認証のユーザーの場合" do
      it "ログインページにリダイレクトされること" do
        get :show

        expect(response).to redirect_to(new_admin_session_path)
        expect(flash[:alert]).to eq("ログインが必要です。")
      end
    end

    context "無効な session[:admin_role] の場合" do
      it "role が 2 の場合はログインページにリダイレクトされること" do
        session[:admin_user_id] = super_admin.id
        session[:admin_role] = 2  # 無効な role

        get :show

        expect(response).to redirect_to(new_admin_session_path)
        expect(flash[:alert]).to eq("ログインが必要です。")
      end

      it "role が nil の場合はログインページにリダイレクトされること" do
        session[:admin_user_id] = super_admin.id
        session[:admin_role] = nil  # ログイン情報なし

        get :show

        expect(response).to redirect_to(new_admin_session_path)
        expect(flash[:alert]).to eq("ログインが必要です。")
      end
    end
  end
end
