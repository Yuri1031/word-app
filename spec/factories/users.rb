FactoryBot.define do
  factory :user do
    name {Faker::Name.last_name}
    nickname { Faker::Internet.username(specifier: 5..8) }
    color_id { rand(1..10) }
    email {Faker::Internet.email}
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end