class Invoice < ApplicationRecord
  validates_presence_of :status
  enum status: %w(pending shipped cancelled)


  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
end
