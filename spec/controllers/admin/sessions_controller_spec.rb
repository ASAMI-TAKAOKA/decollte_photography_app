require 'rails_helper'

RSpec.describe Admin::SessionsController, type: :controller do
  let!(:super_admin) { AdminUser.create!(username: "admin", password: "UMtDj4ZBv%&d@Tzh", role: 1) }
  let!(:regular_admin) { AdminUser.create!(username: "regular_admin", password: "password", role: 0) }

  describe "GET #new" do
    context "未ログイン時" do
      it "ログインページを表示できること" do
        get :new
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
    end

    context "ログイン済みの場合" do
      before { session[:admin_user_id] = super_admin.id }

      it "ダッシュボードにリダイレクトされること" do
        get :new
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:notice]).to eq("すでにログインしています。")
      end
    end
  end

  describe "POST #create" do
    context "ログイン成功時" do
      it "特権管理者がログインできること" do
        post :create, params: { username: "admin", password: "UMtDj4ZBv%&d@Tzh" }
        expect(session[:admin_user_id]).to eq(super_admin.id)
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:notice]).to eq("ログインしました。")
      end

      it "一般管理者がログインできること" do
        post :create, params: { username: "regular_admin", password: "password" }
        expect(session[:admin_user_id]).to eq(regular_admin.id)
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:notice]).to eq("ログインしました。")
      end
    end

    context "ログイン失敗時" do
      it "パスワードが間違っている場合" do
        post :create, params: { username: "admin", password: "wrong_password" }
        expect(session[:admin_user_id]).to be_nil
        expect(response).to redirect_to(new_admin_session_path)
        expect(flash[:alert]).to eq("ログイン情報が正しくありません。")
      end

      it "存在しないユーザー名の場合" do
        post :create, params: { username: "unknown", password: "password" }
        expect(session[:admin_user_id]).to be_nil
        expect(response).to redirect_to(new_admin_session_path)
        expect(flash[:alert]).to eq("ログイン情報が正しくありません。")
      end
    end

    context "すでにログインしている場合" do
      before { session[:admin_user_id] = super_admin.id }

      it "リダイレクトされること" do
        post :create, params: { username: "admin", password: "UMtDj4ZBv%&d@Tzh" }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:notice]).to eq("すでにログインしています。")
      end
    end
  end

  describe "DELETE #destroy" do
    before { session[:admin_user_id] = super_admin.id }

    it "ログアウトできること" do
      delete :destroy
      expect(session[:admin_user_id]).to be_nil
      expect(response).to redirect_to(new_admin_session_path)
      expect(flash[:notice]).to eq("ログアウトしました。")
    end
  end
end
