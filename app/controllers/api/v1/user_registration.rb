module API
  module V1
    class UserRegistration < Grape::API
      include API::V1::Defaults

      resource :users do
        desc "Create User Account"
        params do
          requires :email, type: String, desc: "Email Address"
        end
        post :register do
          user = User.create({:email => params[:email]})
          if user.persisted?
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