FactoryBot.define do
  factory :lesson_type do
    tutor { association :tutor }
    title { Faker::Lorem.words(number: 2).join(' ').capitalize }
    duration_minutes { 60 }
    active { true }
  end
end
