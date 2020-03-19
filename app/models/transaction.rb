class Transaction < ApplicationRecord
  validates_presence_of :result
  enum status: %w(success failed)

  belongs_to :invoice
  has_one :customer, through: :invoice
  has_one :merchant, through: :invoice
  has_many :invoice_items, through: :invoice
  has_many :items, through: :invoice_items
end
