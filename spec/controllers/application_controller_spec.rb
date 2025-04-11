require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let!(:super_admin) { AdminUser.create!(username: "admin", password: "UMtDj4ZBv%&d@Tzh", role: 1) }
  let!(:regular_admin) { AdminUser.create!(username: "regular_admin", password: "password", role: 0) }

  describe "current_user メソッドのテスト" do
    context "ログインしていない場合" do
      before do
        session[:admin_user_id] = nil
      end

      it "current_user が nil を返すこと" do
        expect(controller.current_user).to be_nil
      end
    end

    context "ログインしている場合" do
      before do
        session[:admin_user_id] = super_admin.id
      end

      it "current_user がログイン中のユーザーを返すこと" do
        expect(controller.current_user).to eq(super_admin)
      end
    end
  end

  describe "admin_logged_in? メソッドのテスト" do
    context "ログインしていない場合" do
      before do
        session[:admin_user_id] = nil
      end

      it "admin_logged_in? が false を返すこと" do
        expect(controller.admin_logged_in?).to be_falsey
      end
    end

    context "ログインしている場合" do
      before do
        session[:admin_user_id] = super_admin.id
      end

      it "admin_logged_in? が true を返すこと" do
        expect(controller.admin_logged_in?).to be_truthy
      end
    end
  end
end
