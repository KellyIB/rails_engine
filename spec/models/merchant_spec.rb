require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :invoices}
    it {should have_many(:invoice_items).through(:invoices)}
    it {should have_many(:customers).through(:invoices)}
    it {should have_many(:transactions).through(:invoices)}
  end

  describe "class methods" do
    it "can find the merchant with the most revenue" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      item1 = create(:item, unit_price: 10.00, merchant_id: merchant1.id)
      item2 = create(:item, unit_price: 10.00, merchant_id: merchant1.id)
      item3 = create(:item, unit_price: 10.00, merchant_id: merchant2.id)
      item4 = create(:item, unit_price: 10.00, merchant_id: merchant2.id)
      invoice1 = create(:invoice, merchant_id: merchant1.id)
      invoice2 = create(:invoice, merchant_id: merchant1.id)
      invoice3 = create(:invoice, merchant_id: merchant2.id)
      invoice4 = create(:invoice, merchant_id: merchant2.id)
      invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 10, unit_price: 10.00)
      invoice_item2 = create(:invoice_item, item: item2, invoice: invoice1, quantity: 20, unit_price: 10.00)
      invoice_item3 = create(:invoice_item, item: item1, invoice: invoice2, quantity: 30, unit_price: 10.00)
      invoice_item4 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 40, unit_price: 10.00)
      invoice_item5 = create(:invoice_item, item: item3, invoice: invoice3, quantity: 50, unit_price: 10.00)
      invoice_item6 = create(:invoice_item, item: item4, invoice: invoice3, quantity: 60, unit_price: 10.00)
      invoice_item7 = create(:invoice_item, item: item3, invoice: invoice4, quantity: 70, unit_price: 10.00)
      invoice_item8 = create(:invoice_item, item: item4, invoice: invoice4, quantity: 80, unit_price: 10.00)
      transaction1 = create(:transaction, invoice: invoice1)
      transaction2 = create(:transaction, invoice: invoice2)
      transaction3 = create(:transaction, invoice: invoice3)
      transaction4 = create(:transaction, invoice: invoice4)
# binding.pry
      top_merchant = Merchant.most_revenue(1)
      expect(top_merchant).to eq([merchant2])
    end
  end
end
