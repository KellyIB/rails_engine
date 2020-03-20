class Transaction < ApplicationRecord
  validates_presence_of :credit_card_number
  validates_presence_of :result
  validates_presence_of :result
  enum result: %w(success failed)

  belongs_to :invoice
  has_one :customer, through: :invoice
  has_one :merchant, through: :invoice
  has_many :invoice_items, through: :invoice
  has_many :items, through: :invoice_items
end
