require 'rails_helper'

RSpec.describe Store, type: :model do
  let!(:brand) { Brand.create(name: "TestBrand") }  # Brandを手動で作成

  describe "バリデーション" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:phone_number) }

    it "nameがユニークであること" do
      Store.create!(name: "UniqueStore", address: "Address1", phone_number: "0120-111-111", brand: brand)
      duplicate_store = Store.new(name: "UniqueStore", address: "Address2", phone_number: "0120-222-222", brand: brand)
      expect(duplicate_store).not_to be_valid
      expect(duplicate_store.errors[:name]).to include("はすでに存在します")
    end
  end

  describe "acts_as_list" do
    it "ブランド内での店舗の順番が正しく管理される" do
      store1 = Store.create!(name: "Store1", address: "Address1", phone_number: "0120-111-111", brand: brand)
      store2 = Store.create!(name: "Store2", address: "Address2", phone_number: "0120-222-222", brand: brand)

      expect(store1.position).to eq(1)
      expect(store2.position).to eq(2)
    end
  end

  describe "#move" do
    let!(:store1) { Store.create!(name: "Store1", address: "Address1", phone_number: "0120-111-111", brand: brand) }
    let!(:store2) { Store.create!(name: "Store2", address: "Address2", phone_number: "0120-222-222", brand: brand) }
    let!(:store3) { Store.create!(name: "Store3", address: "Address3", phone_number: "0120-333-333", brand: brand) }

    it "店舗の順番を上げる" do
      expect { store2.move(:higher) }.to change { store2.reload.position }.from(2).to(1)
    end

    it "店舗の順番を下げる" do
      expect { store2.move(:lower) }.to change { store2.reload.position }.from(2).to(3)
    end

    it "無効な方向を指定するとエラーを発生させる" do
      expect { store2.move(:invalid) }.to raise_error(ArgumentError, "Invalid direction: invalid")
    end
  end
end
