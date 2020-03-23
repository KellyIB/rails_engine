class Api::V1::Merchants::FindController < ApplicationController

  def index
      render json: MerchantSerializer.new(Merchant.where(sql_string))
  end

  def show
    render json: MerchantSerializer.new(Merchant.where(sql_string).limit(1))
  end

  private

  def query_params
    params.permit(:name, :created_at, :updated_at)
  end

  def sql_string
    string = ""
    query_params.each do |key, value|
      string += "#{key} ~* '#{value}' AND "
    end
    string = string.delete_suffix(" AND ")
  end
end
