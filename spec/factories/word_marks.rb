FactoryBot.define do
  factory :word_mark do
    review_date { Faker::Time.backward(days: 7) }
    last_marked_at { Faker::Time.backward(days: 7) }
    mark_type { [nil, 0, 1].sample }

    association :user
    association :word
  end
end
