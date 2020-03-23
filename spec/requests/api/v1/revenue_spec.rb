require 'rails_helper'

RSpec.describe "Revenue Queries" do
  before :each do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @merchant3 = create(:merchant)

    @item1 = create(:item, unit_price: 10.00, merchant_id: @merchant1.id)
    @item2 = create(:item, unit_price: 10.00, merchant_id: @merchant1.id)
    @item3 = create(:item, unit_price: 10.00, merchant_id: @merchant2.id)
    @item4 = create(:item, unit_price: 10.00, merchant_id: @merchant2.id)
    @item5 = create(:item, unit_price: 10.00, merchant_id: @merchant3.id)
    @item6 = create(:item, unit_price: 10.00, merchant_id: @merchant3.id)

    @invoice1 = create(:invoice, merchant_id: @merchant1.id)
    @invoice2 = create(:invoice, merchant_id: @merchant1.id)
    @invoice3 = create(:invoice, merchant_id: @merchant2.id)
    @invoice4 = create(:invoice, merchant_id: @merchant2.id)
    @invoice5 = create(:invoice, merchant_id: @merchant3.id)
    @invoice6 = create(:invoice, merchant_id: @merchant3.id)

    @invoice_item1 = create(:invoice_item, item: @item1, invoice: @invoice1, quantity: 10, unit_price: 10.00)
    @invoice_item2 = create(:invoice_item, item: @item2, invoice: @invoice1, quantity: 20, unit_price: 10.00)
    @invoice_item3 = create(:invoice_item, item: @item1, invoice: @invoice2, quantity: 30, unit_price: 10.00)
    @invoice_item4 = create(:invoice_item, item: @item2, invoice: @invoice2, quantity: 40, unit_price: 10.00)
    @invoice_item5 = create(:invoice_item, item: @item3, invoice: @invoice3, quantity: 50, unit_price: 10.00)
    @invoice_item6 = create(:invoice_item, item: @item4, invoice: @invoice3, quantity: 60, unit_price: 10.00)
    @invoice_item7 = create(:invoice_item, item: @item3, invoice: @invoice4, quantity: 70, unit_price: 10.00)
    @invoice_item8 = create(:invoice_item, item: @item4, invoice: @invoice4, quantity: 80, unit_price: 10.00)
    @invoice_item9 = create(:invoice_item, item: @item5, invoice: @invoice5, quantity: 90, unit_price: 10.00)
    @invoice_item10 = create(:invoice_item, item: @item6, invoice: @invoice5, quantity: 100, unit_price: 10.00)
    @invoice_item11 = create(:invoice_item, item: @item5, invoice: @invoice6, quantity: 110, unit_price: 10.00)
    @invoice_item12 = create(:invoice_item, item: @item6, invoice: @invoice6, quantity: 120, unit_price: 10.00)

    @transaction1 = create(:transaction, invoice: @invoice1)
    @transaction2 = create(:transaction, invoice: @invoice2)
    @transaction3 = create(:transaction, invoice: @invoice3)
    @transaction4 = create(:transaction, invoice: @invoice4)
    @transaction5 = create(:transaction, invoice: @invoice5)
    @transaction6 = create(:transaction, invoice: @invoice6)
  end
  it "can find the merchant with the most_revenue" do

    get "/api/v1/merchants/most_revenue?quantity=2"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"][0]["id"]).to eq(@merchant3.id.to_s)
    expect(merchant["data"][1]["id"]).to eq(@merchant2.id.to_s)
  end
end
