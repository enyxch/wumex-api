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
          if user = current_user
            present user, with: User::Entity
          else
            error!({:error => '422', :error_message => user.errors.full_messages.to_s}, 422)
          end
        end
      end

    end
  end
end
