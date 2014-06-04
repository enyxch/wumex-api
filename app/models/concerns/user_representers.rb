module UserRepresenters

  include Grape::Entity::DSL

  entity do
    expose :id
    expose :email
    expose :user_name
    expose :first_name
    expose :last_name
  end

end