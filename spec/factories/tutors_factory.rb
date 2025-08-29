FactoryBot.define do
  factory :tutor do
    user { nil }
    display_name { "MyString" }
    bio { "MyText" }
    timezone { "MyString" }
    settings { "" }
    default_lesson_type { nil }
  end
end
