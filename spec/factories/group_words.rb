FactoryBot.define do
  factory :group_word do
    association :user
    association :word
    association :group
  end
end
