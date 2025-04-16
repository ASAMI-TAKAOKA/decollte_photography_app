require 'rails_helper'

describe StoresController, type: :controller do
  let!(:brand) { Brand.create!(name: "BrandName", slug: "brand-name") }
  let!(:store1) { Store.create!(name: "Store1", address: "Address1", phone_number: "1111111111", brand: brand, position: 1) }
  let!(:store2) { Store.create!(name: "Store2", address: "Address2", phone_number: "2222222222", brand: brand, position: 2) }

  describe "GET #index" do
    it "店舗一覧ページが表示されること" do
      get :index
      expect(response).to be_successful
      expect(assigns(:stores)).to match_array([ store1, store2 ])
    end
  end
end
