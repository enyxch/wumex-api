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
        
        desc "Search Users"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :search
        end
        get :search_users do
          users = User.where("lower(email) like :search OR lower(user_name) like :search OR lower(first_name) like :search OR lower(last_name) like :search", { :search => "%#{params[:search]}%".downcase} )
          present users, with: User::Entity
        end
        
      end

    end
  end
end
