require 'rails_helper'

RSpec.describe Store, type: :model do
  let!(:brand) { Brand.create(name: "TestBrand") }  # Brandを手動で作成

  describe "バリデーション" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:phone_number) }
  end

  describe "global_positionの設定" do
    it "新しい店舗を作成するとき、次に利用可能なglobal_positionが設定される" do
      store = Store.create!(name: "Store1", address: "Address1", phone_number: "0120-111-111", position: 1, brand_id: brand.id)
      expect(store.global_position).to eq(1)  # 新規作成時にglobal_positionが1になることを確認
    end

    it "店舗が存在しない場合、新しく作成した店舗のglobal_positionは1から始まる" do
      Store.delete_all  # テスト開始前に全てのStoreを削除
      store = Store.create!(name: "Store1", address: "Address1", phone_number: "0120-111-111", position: 1, brand_id: brand.id)
      expect(store.global_position).to eq(1)  # 最初のStoreのglobal_positionが1であることを確認
    end
  end

  describe "acts_as_list" do
    it "ブランド内での店舗の順番が正しく管理される" do
      store1 = Store.create!(name: "Store1", address: "Address1", phone_number: "0120-111-111", position: 1, brand_id: brand.id)
      store2 = Store.create!(name: "Store2", address: "Address2", phone_number: "0120-222-222", position: 2, brand_id: brand.id)

      expect(store1.position).to eq(1)
      expect(store2.position).to eq(2)
    end
  end
end
