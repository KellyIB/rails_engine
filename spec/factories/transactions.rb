FactoryBot.define do
  factory :transaction do
    invoice 
    credit_card_number { 1 }
    result { 1 }
  end
end