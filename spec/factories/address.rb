FactoryBot.define do
  factory :address do
    street { "123 St" }
    city  { "Gotham" }
    latitude { 34.156113 }
    longitude { -118.131943 }
    account
  end
end
