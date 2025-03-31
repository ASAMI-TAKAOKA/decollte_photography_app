require 'rails_helper'

RSpec.describe Store, type: :model do
  let!(:brand) { Brand.create(name: "TestBrand") }  # Brandを手動で作成

  describe "バリデーション" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:phone_number) }
  end

  describe "acts_as_list" do
    it "ブランド内での店舗の順番が正しく管理される" do
      store1 = Store.create!(name: "Store1", address: "Address1", phone_number: "0120-111-111", position: 1, brand_id: brand.id)
      store2 = Store.create!(name: "Store2", address: "Address2", phone_number: "0120-222-222", position: 2, brand_id: brand.id)

      expect(store1.position).to eq(1)
      expect(store2.position).to eq(2)
    end
  end

  describe "#move_within_brand" do
    let!(:store1) { Store.create!(name: "Store1", address: "Address1", phone_number: "0120-111-111", brand: brand) }
    let!(:store2) { Store.create!(name: "Store2", address: "Address2", phone_number: "0120-222-222", brand: brand) }
    let!(:store3) { Store.create!(name: "Store3", address: "Address3", phone_number: "0120-333-333", brand: brand) }

    it "店舗の順番を上げる" do
      expect { store2.move_within_brand(:higher) }.to change { store2.reload.position }.from(2).to(1)
    end

    it "店舗の順番を下げる" do
      expect { store2.move_within_brand(:lower) }.to change { store2.reload.position }.from(2).to(3)
    end

    it "無効な方向を指定するとエラーを発生させる" do
      expect { store2.move_within_brand(:invalid) }.to raise_error(ArgumentError, "Invalid direction: invalid")
    end
  end
end
