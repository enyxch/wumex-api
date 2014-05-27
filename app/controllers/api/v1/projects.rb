module API
  module V1
    class Projects < Grape::API
      include API::V1::Defaults
      include API::V1::Authorization
      helpers API::V1::ApiHelpers
      
      resource :projects do
        desc "Return List of Projects for Authorized User"
        params do
          requires :token, type: String, desc: "Authorization"
        end
        get do
          current_user.projects
        end
      
        desc "Authorize User can create Projects"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :title, type: String
          optional :description, type: String
          optional :deadline, type: Date
          optional :percent_done, type: Integer
        end
        post :create do
          project = Project.create_project(current_user, params)
          if project.persisted?
            status(201)
            {
              status: 'ok'
            }
          else
            error!({:error => '4220', :error_message => project.errors.full_messages.to_s}, 422)
          end
        end
        
        desc "Authorize User can delete Projects"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :id, type: Integer
        end
        delete :delete do
          project = current_user.projects.find_by_id(params[:id])
          return error!({:error => '4012', :error_message => "Unauthorized"}, 401) unless project
          if project.destroy
            status(200)
            {
              status: 'ok'
            }
          else
            error!({:error => '4220', :error_message => project.errors.full_messages.to_s}, 422)
          end
        end
        
      end
    end
  end
end
