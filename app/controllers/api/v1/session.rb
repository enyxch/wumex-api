module API
  module V1
    class Session < Grape::API
      include API::V1::Defaults
      
      resource :session do
        desc "Authenticate user"
        params do
          requires :password, type: String
          requires :email, type: String 
        end
        
        post :login do
          email = params[:email]
          password = params[:password]

          @user = User.find_by_email(email.downcase) #Find the User
          if @user.nil? # If user does not exist
            error!({:error => '401', :error_message => "Invalid email or password."}, 401)
            return
          end

          @user.ensure_authentication_token! #Generates a new token for the user
          if !@user.valid_password?(password) # Check the password
            error!({:error => '401', :error_message => "Invalid email or passoword."}, 401)
            return
          else
            @user.save #Save the token into the database
            status(200)
            {
              status: 'Logged in',
              token: @user.authentication_token
            }
          end
        end

        delete :logout do
          token = (params[:token] || headers['Authorization-Token'])
          @user = User.where(authentication_token: token).first
          if @user.nil?
            error!({:error => '404', :error_message => "Invalid token."}, 404)
          else
            @user.reset_authentication_token!
            status(200)
            {
              status: 'Logged out',
              token: token
            }
          end
        end
      end

    end
  end
end  
