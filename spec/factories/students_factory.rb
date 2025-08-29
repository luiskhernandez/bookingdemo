FactoryBot.define do
  factory :student do
    user { nil }
    first_name { "MyString" }
    last_name { "MyString" }
    settings { "" }
  end
end
