require 'faker'
FactoryGirl.define do
  factory :label do
    name {Faker::Lorem.word}
    project
  end
end
