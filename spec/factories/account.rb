FactoryBot.define do
  sequence :email do |n|
    "account#{n}@example.com"
  end

  factory :account do
    email
    username "cgotcha"
    password "cinemanjar"
    address
  end
end
