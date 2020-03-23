FactoryBot.define do
  factory :transaction do
    invoice
    credit_card_number { 4440486512520258 }
    result { 0 }
  end
end
