FactoryBot.define do
  factory :lesson_type do
    tutor { nil }
    title { "MyString" }
    duration_minutes { 1 }
    active { false }
  end
end
