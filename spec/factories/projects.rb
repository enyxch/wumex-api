require 'faker'
FactoryGirl.define do
  factory :project do
    title {Faker::Lorem.word}
    description {Faker::Lorem.sentence(3)}
    deadline (Date.today + 3)

    factory :project_with_document do
      after(:create) do |project|
        create(:document, project: project)
      end
    end

    factory :project_with_label do
      after(:create) do |project|
        create(:label, project: project)
      end
    end

    factory :project_with_note do
      after(:create) do |project|
        create(:note, project: project)
      end
    end

    factory :project_with_task do
      after(:create) do |project|
        create(:task, project: project)
      end
    end

  end
end
