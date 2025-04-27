FactoryBot.define do
  factory :category do
    category_name { Faker::Name.last_name }
    association :user
  end
end