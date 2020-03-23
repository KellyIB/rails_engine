class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices

  # def self.most_revenue(quantity)
  #   Merchant.joins(:transactions)
  #   .joins(:invoice_items)
  #   .where("transactions.result = 'success'")
  #   .select('merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
  #   .group(:id)
  #   .order(revenue: :desc)
  #   .limit("#{quantity}")
  # end
  #
  def self.most_revenue(quantity)
    binding.pry
    Merchant.joins(:transactions).joins(:invoice_items).where("transactions.result = '0'").select('merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as revenue').group(:id).order(revenue: :desc).limit("#{quantity}")
  end

end
