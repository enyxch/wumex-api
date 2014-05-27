require 'faker'
FactoryGirl.define do
  factory :note do
    name {Faker::Lorem.word}
    body {Faker::Lorem.sentence(3)}
    project
    task
    #meeting #TODO: uncomment, when meeting model is present
  end
end
