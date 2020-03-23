require 'rails_helper'

RSpec.describe "Items API" do
  before :each do
    Merchant.delete_all
    @merchant = Merchant.create(name: "Bob's Big Boys")
  end

  it 'send a list of items' do
     item1 = create(:item, merchant_id: @merchant.id)
     item2 = create(:item, merchant_id: @merchant.id)
     item3 = create(:item, merchant_id: @merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items["data"].count).to eq(3)
  end

  it "can get one item by its id" do
    id = create(:item, merchant_id: @merchant.id).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["id"]).to eq(id.to_s)
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
    first_item = create(:item, merchant_id: @merchant.id)
    id = create(:item, merchant_id: @merchant.id).id
    previous_name = Item.last.name

    item_params = { name: "Bolder Holder"}

    put "/api/v1/items/#{id}", params: item_params
    item = Item.find(id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Bolder Holder")
    expect(first_item.name).to_not eq("Bolder Holder")
  end

  it "can destroy an item" do
    item = create(:item, merchant_id: @merchant.id)

    expect(Item.count).to eq(1)

    expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can find the merchant an item belongs to" do
    item = create(:item, merchant_id: @merchant.id)

    get "/api/v1/items/#{item.id}/merchants"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq(@merchant.id.to_s)
  end
  it 'can find a list of items that contain a fragment, case insensitive' do
    Item.delete_all
    merchant = Merchant.create(name: "Bob's Big Boys")
      item1 = Item.create(name: "Bob's Top Hat", description: "It goes on top", unit_price: 5.50, merchant_id: merchant.id)
      item2 = Item.create(name: "Bob's Toy Car", description: "Drives Fast", unit_price: 6.5, merchant_id: merchant.id)
      item3 = Item.create(name: "Dodo Bird Stuffie", description: "Ever seen one?", unit_price: 2.43, merchant_id: merchant.id)
      item4 = Item.create(name: "Bottled Bob Breath", description: "Potent", unit_price: 23.20, merchant_id: merchant.id)
      item5 = Item.create(name: "Got Bob Tshirt", description: "Everyone needs one", unit_price: 99.90, merchant_id: merchant.id)
      item6 = Item.create(name: "Hamberder Hat", description: "Hahahaha", unit_price: 1.5, merchant_id: merchant.id)
      item7 = Item.create(name: "Earwig Spray", description: "Keeps them away", unit_price: 14.50, merchant_id: merchant.id)
      item8 = Item.create(name: "Bob's Tears", description: "Magical", unit_price: 99.00, merchant_id: merchant.id)
    expect(Item.all.count).to eq(8)


    get "/api/v1/items/find_all?name=BOB"

    expect(response).to be_successful
    items = JSON.parse(response.body)
    # binding.pry

    expect(items["data"].count).to eq(5)
    expect(items["data"][0]["id"].to_i).to eq(item1.id)
    expect(items["data"][1]["id"].to_i).to eq(item2.id)
    expect(items["data"][2]["id"].to_i).to eq(item4.id)
    expect(items["data"][3]["id"].to_i).to eq(item5.id)
    expect(items["data"][4]["id"].to_i).to eq(item8.id)


    names = items["data"].map do |item|
      item["attributes"]["name"]
    end

    expect(names.sort).to eq(["Bob's Tears", "Bob's Top Hat", "Bob's Toy Car", "Bottled Bob Breath", "Got Bob Tshirt"])
  end

  it 'can find a list of items that contain a fragment on 2 attributes, case insensitive' do
    Item.delete_all
    merchant = Merchant.create(name: "Bob's Big Boys")
      item1 = Item.create(name: "Bob's Top Hat", description: "It goes on top", unit_price: 5.50, merchant_id: merchant.id)
      item2 = Item.create(name: "Bob's Toy Car", description: "Ever seen one?", unit_price: 6.5, merchant_id: merchant.id)
      item3 = Item.create(name: "Dodo Bird Stuffie", description: "Get them while you can", unit_price: 2.43, merchant_id: merchant.id)
      item4 = Item.create(name: "Bottled Bob Breath", description: "Potent", unit_price: 23.20, merchant_id: merchant.id)
      item5 = Item.create(name: "Got Bob Tshirt", description: "Everyone needs one", unit_price: 99.90, merchant_id: merchant.id)
      item6 = Item.create(name: "Hamberder Hat", description: "Hahahaha", unit_price: 1.5, merchant_id: merchant.id)
      item7 = Item.create(name: "Earwig Spray", description: "Keeps them away", unit_price: 14.50, merchant_id: merchant.id)
      item8 = Item.create(name: "Bob's Tears", description: "Magical", unit_price: 99.00, merchant_id: merchant.id)
    expect(Item.all.count).to eq(8)

    get "/api/v1/items/find_all?name=BOB&description=ever"

    expect(response).to be_successful
    items = JSON.parse(response.body)

    expect(items["data"].count).to eq(2)
    expect(items["data"][0]["id"].to_i).to eq(item2.id)
    expect(items["data"][1]["id"].to_i).to eq(item5.id)

    names = items["data"].map do |item|
      item["attributes"]["name"]
    end

    expect(names.sort).to eq(["Bob's Toy Car", "Got Bob Tshirt"])
  end

    it 'can find the first item that contain a fragment, case insensitive' do
      Item.delete_all
        item1 = Item.create(name: "Bob's Top Hat", description: "It goes on top", unit_price: 5.50, merchant_id: @merchant.id)
        item2 = Item.create(name: "Bob's Toy Car", description: "Ever seen one?", unit_price: 6.5, merchant_id: @merchant.id)
        item3 = Item.create(name: "Dodo Bird Stuffie", description: "Get them while you can", unit_price: 2.43, merchant_id: @merchant.id)
        item4 = Item.create(name: "Bottled Bob Breath", description: "Potent", unit_price: 23.20, merchant_id: @merchant.id)
        item5 = Item.create(name: "Got Bob Tshirt", description: "Everyone needs one", unit_price: 99.90, merchant_id: @merchant.id)
        item6 = Item.create(name: "Hamberder Hat", description: "Hahahaha", unit_price: 1.5, merchant_id: @merchant.id)
        item7 = Item.create(name: "Earwig Spray", description: "Keeps them away", unit_price: 14.50, merchant_id: @merchant.id)
        item8 = Item.create(name: "Bob's Tears", description: "Magical", unit_price: 99.00, merchant_id: @merchant.id)

      expect(Item.all.count).to eq(8)

      get "/api/v1/items/find?name=bob"

      expect(response).to be_successful
      item = JSON.parse(response.body)

      expect(item["data"].count).to eq(1)
      expect(item["data"][0]["id"].to_i).to eq(item1.id)
      expect(item["data"][0]["attributes"]["name"]).to eq("Bob's Top Hat")
    end


end
