FactoryGirl.define do
  factory :project do
    title Faker::Lorem.word
    description Faker::Lorem.sentence(3)
    deadline (Date.today + 3)
  end
end
