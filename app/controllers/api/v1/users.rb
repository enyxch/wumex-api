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
          users = User.where("email like :search OR user_name like :search OR first_name like :search OR last_name like :search", { :search => "%#{params[:search]}%".downcase} )
          present users, with: User::Entity
        end
        
      end

    end
  end
end
