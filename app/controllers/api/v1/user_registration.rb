module API
  module V1
    class UserRegistration < Grape::API
      include API::V1::Defaults

      resource :users do
        desc "Create User Account"
        params do
          requires :password, type: String
          requires :email, type: String
          optional :user_name, type: String
          optional :first_name, type: String
          optional :last_name, type: String
        end
        post :register do
          user = User.create_user(params)
          if user.persisted?
            user.ensure_authentication_token!
            user.save
            status(201)
            {
              status: 'ok',
              token: user.authentication_token
            }
          else
            error!({:error => '422', :error_message => user.errors.full_messages.to_s}, 422)
          end
        end
      end

    end
  end
end
