module API
  module V1
    class Sessions < Grape::API
      include API::V1::Defaults

      resource :sessions do
        desc "Create sessions"
        params do
          requires :password, type: String
          requires :email, type: String
        end

        post :login do
          email = params[:email]
          password = params[:password]

          user = User.find_by_email(email.downcase)
          if user.nil?
            error!({:error => '4011', :error_message => "Invalid email or password."}, 401)
            return
          end

          if !user.valid_password?(password)
            error!({:error => '4011', :error_message => "Invalid email or password."}, 401)
            return
          else
            user.ensure_authentication_token!
            user.save
            status(201)
            {
              status: 'ok',
              token: user.authentication_token
            }
          end
        end

        desc "Destroy sessions"
        params do
          requires :token, type: String, desc: "Authorization"
        end
        delete :logout do
          token = (params[:token] || headers['Authorization-Token'])
          user = User.where(authentication_token: token).first
          if user.nil?
            error!({:error => '4041', :error_message => "Invalid token."}, 404)
          else
            user.reset_authentication_token!
            status(200)
            {
              status: 'ok',
              token: token
            }
          end
        end
      end

    end
  end
end
