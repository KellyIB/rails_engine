require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
  end

  it "can create a new merchant" do
    merchant_params = { name: "Scrubby's Bubbles" }

    post "/api/v1/merchants", params: {merchant: merchant_params }
    merchant = Merchant.last

    expect(response).to be_successful
    expect(merchant.name).to eq("Scrubby's Bubbles")
  end

  it "can update an existing merchant" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: "Drip Dries" }

    put "/api/v1/merchants/#{id}", params: {merchant: merchant_params}
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq("Drip Dries")
  end

  it "can destroy an item" do
     merchant_id = create(:merchant).id

    expect(Merchant.count).to eq(1)

    expect{ delete "/api/v1/merchants/#{merchant_id}" }.to change(Merchant, :count).by(-1)

    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant_id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
