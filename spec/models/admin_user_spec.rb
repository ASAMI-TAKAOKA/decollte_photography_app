require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  let(:valid_password) { "password" }

  describe "バリデーション" do
    subject { described_class.new(username: username, password: password, role: role) }

    let(:username) { "admin_user" }
    let(:password) { valid_password }
    let(:role) { :regular_admin }

    context "ユーザー名" do
      context "空の場合" do
        let(:username) { nil }
        it "無効であること" do
          expect(subject).not_to be_valid
          expect(subject.errors[:username]).to include("を入力してください")
        end
      end

      context "一意であること" do
        before { described_class.create!(username: username, password: valid_password, role: role) }
        it "無効であること" do
          expect(subject).not_to be_valid
          expect(subject.errors[:username]).to include("はすでに存在します")
        end
      end
    end

    context "パスワード" do
      let(:password) { "short" }
      it "6文字以上であること" do
        expect(subject).not_to be_valid
        expect(subject.errors[:password]).to include("は6文字以上で入力してください")
      end
    end

    context "役割" do
      it "0または1以外は無効であること" do
        admin_user = described_class.new(username: "user", password: valid_password)
        # enum で無効な値を強制的にセット
        expect {
          admin_user.role = 2
        }.to raise_error(ArgumentError, "'2' is not a valid role")
      end
    end
  end

  describe "コールバック" do
    it "新しいレコードでロールがデフォルトで0に設定されること" do
      admin_user = described_class.new(username: "new_user", password: valid_password)
      expect(admin_user.role).to eq("regular_admin")
    end
  end
end
