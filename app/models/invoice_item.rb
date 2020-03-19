class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity
  validates_presence_of :unit_price

  validates_numericality_of :quantity
  validates_numericality_of :unit_price

  belongs_to :item
  belongs_to :invoice
  has_one :customer, through: :invoice
  has_one :merchant, through: :invoice
  has_many :transactions, through: :invoice
end
