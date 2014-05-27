# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    name Faker::Lorem.word
    description Faker::Lorem.sentence(3)
    deadline (Date.today+3)
    task_type 'normal'
    priority 'low'
    state 'running'
    time_spent '1H'
    time_estimated '5H'
  end
end
