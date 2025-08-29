FactoryBot.define do
  factory :student do
    user { association :user }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    settings { {} }
  end
end
