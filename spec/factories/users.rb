require 'faker'
FactoryGirl.define do
  factory :user do
    sequence(:email)    { |n| "person#{n}@example.com" }
    sequence(:user_name) { |n| "person#{n}" }
    password "123456"
  end
end
