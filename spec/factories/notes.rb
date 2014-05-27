# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note do
    name Faker::Lorem.word
    body Faker::Lorem.sentence(3)
  end
end
