require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe "バリデーション" do
    subject { described_class.new(name: name, slug: slug) }

    let(:name) { "TestBrand" }
    let(:slug) { nil }

    context "name" do
      context "空の場合" do
        let(:name) { nil }
        it { is_expected.not_to be_valid }
        it "エラーが出ること" do
          subject.validate
          expect(subject.errors[:name]).to include("を入力してください")
        end
      end

      context "一意であること" do
        before { described_class.create!(name: name) }
        it { is_expected.not_to be_valid }
        it "エラーが出ること" do
          subject.validate
          expect(subject.errors[:name]).to include("はすでに存在します")
        end
      end
    end

    context "slug" do
      context "空の場合でも自動生成されること" do
        it "slug が生成される" do
          subject.validate
          expect(subject.slug).to eq("testbrand")
        end
      end

      context "一意であること" do
        before { described_class.create!(name: "ExistingBrand", slug: "custom-slug") }
        let(:slug) { "custom-slug" }
        it { is_expected.not_to be_valid }
        it "エラーが出ること" do
          subject.validate
          expect(subject.errors[:slug]).to include("はすでに存在します")
        end
      end
    end
  end

  describe "slugの生成" do
    it "ブランド名からslugが生成されること" do
      brand = described_class.create!(name: "Test Brand")
      expect(brand.slug).to eq("test-brand")
    end

    it "slugがすでにある場合はそのまま使われること" do
      brand = described_class.new(name: "Another Brand", slug: "custom-slug")
      brand.validate
      expect(brand.slug).to eq("custom-slug")
    end
  end
end
