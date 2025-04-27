FactoryBot.define do
  factory :word do
    title { "test" }
    question { "test" }
    answer { "テスト" }
    
    association :user
    association :category
  end
end