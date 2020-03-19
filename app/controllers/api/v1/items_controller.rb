class Api::V1::ItemsController < ApplicationController

  def index
    render json: Item.all
  end

  def show
    render json: Item.find(params[:id])
  end

  def create
    # binding.pry
     merchant = Merchant.find(params[:merchant_id])
    render json: merchant.items.create(item_params)
   end

  def update
    render json: Item.update(item_params)
  end

  def destroy
    render json: Item.delete(params[:id])

  end
  private

   def item_params
     params.permit(:name, :description, :unit_price, :merchant_id)
   end

end
