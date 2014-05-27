require 'faker'
FactoryGirl.define do
  factory :document do
    name {Faker::Lorem.word}
    document_type {Faker::Lorem.word}
    project
  end
end
