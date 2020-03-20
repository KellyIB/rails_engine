FactoryBot.define do
  factory :customer do
    first_name { Faker::Superhero.prefix }
    last_name { Faker::Superhero.descriptor }
  end
end
