require 'faker'
FactoryGirl.define do
  factory :task do
    name {Faker::Lorem.word}
    description {Faker::Lorem.sentence(3)}
    deadline (Date.today+3)
    task_type 'normal'
    priority 'low'
    state 'running'
    time_spent '1H'
    time_estimated '5H'
    label
    project
    user

    factory :task_with_document do
      after(:create) do |task|
        create(:document, task_id: task.id)
      end
    end
  end
end
