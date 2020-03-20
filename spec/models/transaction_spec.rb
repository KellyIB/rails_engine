require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "validations" do
    it { should validate_presence_of :result }
    it { should validate_presence_of :credit_card_number }
  end

  describe "relationships" do
    it {should belong_to :invoice}
    it {should have_one(:customer).through(:invoice)}
    it {should have_one(:merchant).through(:invoice)}
    it {should have_many(:invoice_items).through(:invoice)}
    it {should have_many(:items).through(:invoice_items)}
  end
end
