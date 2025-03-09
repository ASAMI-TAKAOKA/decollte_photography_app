require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe "バリデーションのテスト" do
    it "username、password、role が有効な場合は保存できる" do
      admin_user = AdminUser.new(username: "regular_admin_user", password: "password123", role: 0)
      expect(admin_user).to be_valid
    end

    it "username がない場合は無効になる" do
      admin_user = AdminUser.new(password: "password123", role: 0)
      expect(admin_user).to be_invalid
      expect(admin_user.errors[:username]).to include("can't be blank")
    end

    it "username が重複している場合は無効になる" do
      AdminUser.create!(username: "regular_admin_user", password: "password123", role: 0)
      duplicate_user = AdminUser.new(username: "regular_admin_user", password: "password456", role: 0)

      expect(duplicate_user).to be_invalid
      expect(duplicate_user.errors[:username]).to include("has already been taken")
    end

    it "password が6文字未満の場合は無効になる" do
      admin_user = AdminUser.new(username: "regular_admin_user", password: "short", role: 0)
      expect(admin_user).to be_invalid
      expect(admin_user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it "role が 0 または 1 以外の場合は無効になる" do
      admin_user = AdminUser.new(username: "regular_admin_user", password: "password123", role: 2)
      expect(admin_user).to be_invalid
      expect(admin_user.errors[:role]).to include("is not included in the list")
    end

    it "role が nil の場合は無効になる" do
      admin_user = AdminUser.new(username: "regular_admin_user", password: "password")
      admin_user.role = nil  # role を nil にセット
      expect(admin_user).to be_invalid
      expect(admin_user.errors[:role]).to include("can't be blank")  # presence: true のエラーメッセージ
      expect(admin_user.errors[:role]).to include("is not included in the list")  # inclusion のエラーメッセージ
    end
  end

  describe "デフォルト値のテスト" do
    it "role のデフォルト値が 0 であること" do
      admin_user = AdminUser.new(username: "regular_admin_user", password: "password123")
      expect(admin_user.role).to eq(0)
    end
  end

  describe "パスワードのセキュリティテスト" do
    it "パスワードが正しくハッシュ化されて保存されること" do
      admin_user = AdminUser.create!(username: "regular_admin_user", password: "secure_password", role: 0)
      expect(admin_user.authenticate("secure_password")).to be_truthy
      expect(admin_user.authenticate("wrong_password")).to be_falsey
    end
  end

  describe "特権管理者の制約" do
    it "特権管理者 (role: 1) が 1 人しか作れないこと" do
      AdminUser.create!(username: "super_admin_user", password: "password123", role: 1)

      another_admin = AdminUser.new(username: "another_super_admin_user", password: "password456", role: 1)
      expect(another_admin).to be_invalid
      expect(another_admin.errors[:role]).to include("特権管理者はすでに存在しています")
    end
  end
end
