module ProjectRepresenters

  include Grape::Entity::DSL

  entity do
    expose :id
    expose :title
    expose :description
    expose :deadline
    expose :percent_done
  end

end