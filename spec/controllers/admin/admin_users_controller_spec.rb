require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe "バリデーション" do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_inclusion_of(:role).in_array([ 0, 1 ]) }
  end

  describe "デフォルト値の設定" do
    it "新しい管理者の role がデフォルトで 0 になる" do
      admin_user = AdminUser.new(username: "new_admin", password: "password")
      expect(admin_user.role).to eq(0)
    end
  end

  describe "特権管理者の制限" do
    before do
      AdminUser.create!(username: "admin", password: "password", role: 1)
    end

    it "特権管理者が1人しか存在しないこと" do
      new_admin = AdminUser.new(username: "new_admin", password: "password", role: 1)
      expect(new_admin).to_not be_valid
      expect(new_admin.errors[:role]).to include("特権管理者はすでに存在しています")
    end

    it "特権管理者がいない場合、新規作成できること" do
      AdminUser.delete_all
      admin_user = AdminUser.new(username: "super_admin", password: "password", role: 1)
      expect(admin_user).to be_valid
    end
  end
end
