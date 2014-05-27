# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    name Faker::Lorem.word
    document_type Faker::Lorem.word
  end
end
