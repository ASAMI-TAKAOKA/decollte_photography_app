require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe "バリデーション" do
    it "ユーザー名が空でないこと" do
      admin_user = AdminUser.new(username: nil, password: "password")
      expect(admin_user).to_not be_valid
      expect(admin_user.errors[:username]).to include("を入力してください")
    end

    it "ユーザー名が一意であること" do
      AdminUser.create!(username: "admin", password: "password", role: 1)
      admin_user = AdminUser.new(username: "admin", password: "password")
      expect(admin_user).to_not be_valid
      expect(admin_user.errors[:username]).to include("はすでに存在します")
    end

    it "パスワードが6文字以上であること" do
      admin_user = AdminUser.new(username: "new_user", password: "short")
      expect(admin_user).to_not be_valid
      expect(admin_user.errors[:password]).to include("は6文字以上で入力してください")
    end

    it "役割が0または1であること" do
      admin_user = AdminUser.new(username: "user", password: "password", role: 2)
      expect(admin_user).to_not be_valid
      expect(admin_user.errors[:role]).to include("は一覧にありません")
    end
  end

  describe "コールバック" do
    it "新しいレコードでロールがデフォルトで0に設定されること" do
      admin_user = AdminUser.new(username: "new_user", password: "password")
      expect(admin_user.role).to eq(0)
    end
  end

  describe "カスタムバリデーション" do
    it "特権管理者が1人しか存在しないこと" do
      AdminUser.create!(username: "admin", password: "password", role: 1)
      new_admin_user = AdminUser.new(username: "new_admin", password: "password", role: 1)
      expect(new_admin_user).to_not be_valid
      expect(new_admin_user.errors[:role]).to include("特権管理者はすでに存在しています")
    end

    it "特権管理者がいない場合は問題ないこと" do
      admin_user = AdminUser.new(username: "new_admin", password: "password", role: 1)
      expect(admin_user).to be_valid
    end
  end
end
