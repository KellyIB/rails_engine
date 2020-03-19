require 'rails_helper'

RSpec.describe "Items API" do
  before :each do
    @merchant = create(:merchant)
  end
  it 'send a list of items' do
     item1 = create(:item, merchant_id: @merchant.id)
     item2 = create(:item, merchant_id: @merchant.id)
     item3 = create(:item, merchant_id: @merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items.count).to eq(3)
  end

  it "can get one item by its id" do
    id = create(:item, merchant_id: @merchant.id).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["id"]).to eq(id)
  end

  it "can create a new item" do
    item_params = { name: "Wooden Tub", description: "Won't last long, but it's ecofriendly!", unit_price: "47", merchant_id: @merchant.id }
# binding.pry
    post "/api/v1/items", params: item_params
    item = Item.last

    expect(response).to be_successful
    expect(item.name).to eq("Wooden Tub")
  end

  it "can update an existing item" do
    id = create(:item, merchant_id: @merchant.id).id
    previous_name = Item.last.name
    item_params = { name: "Bolder Holder"}

    put "/api/v1/items/#{id}", params: item_params
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Bolder Holder")
  end

  it "can destroy an item" do
    item = create(:item, merchant_id: @merchant.id)

    expect(Item.count).to eq(1)

    expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end


  xit "can find the merchant an item belongs to" do
    item = create(:item, merchant_id: @merchant.id)


    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant).to eq(@merchant)
  end

end
