class Api::V1::Merchants::RevenueController < ApplicationController

  def most_revenue
    Merchant.most_revenue(params[:quantity])
    # Merchant.joins(:transactions).joins(:invoice_items).where("transactions.result = '0'").select('merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as revenue').group(:id).order(revenue: :desc).limit("#{params[:quantity]}")
  end





end
