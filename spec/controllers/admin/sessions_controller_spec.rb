require 'rails_helper'

RSpec.describe Admin::SessionsController, type: :controller do
  let!(:super_admin) { AdminUser.create!(username: "admin", password: "password", role: 1) }
  let!(:regular_admin) { AdminUser.create!(username: "regular_admin", password: "password", role: 0) }

  describe "GET #new" do
    it "ログインページを表示できること" do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "ログイン成功時" do
      it "特権管理者がログインできること" do
        post :create, params: { username: "admin", password: "password" }

        expect(session[:admin_user_id]).to eq(super_admin.id)
        expect(session[:admin_role]).to eq(1)
        expect(response).to redirect_to(admin_dashboards_path)
        expect(flash[:notice]).to eq("ログインしました。")
      end

      it "一般管理者がログインできること" do
        post :create, params: { username: "regular_admin", password: "password" }

        expect(session[:admin_user_id]).to eq(regular_admin.id)
        expect(session[:admin_role]).to eq(0)
        expect(response).to redirect_to(admin_dashboards_path)
        expect(flash[:notice]).to eq("ログインしました。")
      end
    end

    context "ログイン失敗時" do
      it "存在しないユーザーでログインできないこと" do
        post :create, params: { username: "non_existent", password: "password" }

        expect(session[:admin_user_id]).to be_nil
        expect(response).to redirect_to(new_admin_session_path)
        expect(flash[:alert]).to eq("ログイン情報が正しくありません。")
      end

      it "間違ったパスワードでログインできないこと" do
        post :create, params: { username: "admin", password: "wrong_password" }

        expect(session[:admin_user_id]).to be_nil
        expect(response).to redirect_to(new_admin_session_path)
        expect(flash[:alert]).to eq("ログイン情報が正しくありません。")
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      session[:admin_user_id] = super_admin.id
      session[:admin_role] = super_admin.role
    end

    it "ログアウトできること" do
      delete :destroy

      expect(session[:admin_user_id]).to be_nil
      expect(session[:admin_role]).to be_nil
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:notice]).to eq("ログアウトしました。")
    end
  end
end
