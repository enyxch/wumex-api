module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults
      include API::V1::Authorization
      helpers API::V1::ApiHelpers

      resource :users do
        desc "Get User Information for Current User"
        params do
          requires :token, type: String, desc: "Authorization"
        end
        get :user do
          present current_user, with: User::Entity
        end
      end

    end
  end
end
