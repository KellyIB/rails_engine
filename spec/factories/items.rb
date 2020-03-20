FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Marketing.buzzwords }
    unit_price { 10.0 }
    merchant
  end
end
