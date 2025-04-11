require 'rails_helper'

RSpec.describe Store, type: :model do
  let!(:brand) { Brand.create!(name: "TestBrand") }

  describe "バリデーション" do
    subject { described_class.new(name: name, address: address, phone_number: phone_number, brand: brand) }

    let(:name) { "TestStore" }
    let(:address) { "Test Address" }
    let(:phone_number) { "0120-111-111" }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:phone_number) }

    context "nameのユニーク性" do
      before { described_class.create!(name: name, address: "Address1", phone_number: "0120-111-111", brand: brand) }

      it { is_expected.not_to be_valid }
      it "エラーが出ること" do
        subject.validate
        expect(subject.errors[:name]).to include("はすでに存在します")
      end
    end
  end

  describe "acts_as_list" do
    let!(:store1) { described_class.create!(name: "Store1", address: "Address1", phone_number: "0120-111-111", brand: brand) }
    let!(:store2) { described_class.create!(name: "Store2", address: "Address2", phone_number: "0120-222-222", brand: brand) }

    it "ブランド内での店舗の順番が正しく管理される" do
      expect(store1.position).to eq(1)
      expect(store2.position).to eq(2)
    end

    it "店舗の順序を上げることができる" do
      store2.move_higher
      expect(store2.reload.position).to eq(1)
      expect(store1.reload.position).to eq(2)
    end
  end
end
