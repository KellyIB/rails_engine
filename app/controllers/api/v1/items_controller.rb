class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    render json: ItemSerializer.new(merchant.items.create(item_params))
   end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    # binding.pry
    render json: ItemSerializer.new(item)
  end

  def destroy
    render json: ItemSerializer.new(Item.destroy(params[:id]))
    # render json: ItemSerializer.new(Item.find(params[:id]))
    # Item.delete(params[:id])
  end

  private

   def item_params
     params.permit(:name, :description, :unit_price, :merchant_id)
   end

end
