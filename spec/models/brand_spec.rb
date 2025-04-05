require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe "バリデーション" do
    it "nameが空でないこと" do
      brand = Brand.new(name: nil)
      expect(brand).to_not be_valid
      expect(brand.errors[:name]).to include("を入力してください")
    end

    it "nameが一意であること" do
      Brand.create!(name: "UniqueBrand")
      brand = Brand.new(name: "UniqueBrand")
      expect(brand).to_not be_valid
      expect(brand.errors[:name]).to include("はすでに存在します")
    end

    it "slugが空でないこと" do
      brand = Brand.new(name: "Brand Name")
      expect(brand).to be_valid  # nameがあればslugが自動生成される
      brand.validate  # バリデーションを手動で実行
      expect(brand.slug).to_not be_nil
      expect(brand.slug).to eq("brand-name")
    end

    it "slugが一意であること" do
      Brand.create!(name: "Brand1")
      brand = Brand.new(name: "Brand2", slug: "brand1")
      expect(brand).to_not be_valid
      expect(brand.errors[:slug]).to include("はすでに存在します")
    end
  end

  describe "slugの生成" do
    it "ブランド名からslugが生成されること" do
      brand = Brand.create!(name: "Test Brand")
      expect(brand.slug).to eq("test-brand")
    end

    it "slugが既にある場合は生成されないこと" do
      brand = Brand.new(name: "Another Brand", slug: "custom-slug")
      brand.validate
      expect(brand.slug).to eq("custom-slug")
    end
  end

  describe "slugの変更バリデーション" do
    it "slugは更新できないこと" do
      brand = Brand.create!(name: "Original Brand")
      brand.slug = "new-slug"
      expect(brand).to_not be_valid
      expect(brand.errors[:slug]).to include("は変更できません")
    end
  end
end
