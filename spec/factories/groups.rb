FactoryBot.define do
  factory :group do
    group_name { "test group" }
    group_description { "test group introduce" }
    
    association :user
  end
end