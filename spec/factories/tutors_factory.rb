FactoryBot.define do
  factory :tutor do
    user { association :user }
    display_name { Faker::Name.name }
    bio { Faker::Lorem.paragraph }
    timezone { "America/Bogota" }
    settings { {} }
  end
end
