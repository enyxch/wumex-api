module API
  module V1
    class Projects < Grape::API
      include API::V1::Defaults
      include API::V1::Authorization
      helpers API::V1::ApiHelpers

      resource :projects do
        desc "List Projects"
        params do
          requires :token, type: String, desc: "Authorization"
        end
        get do
          current_user.projects
        end

        desc "Show Project"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :project_id, type: Integer
        end
        get :project do
          project = current_user.projects.where(:id => params[:project_id]).first
          if project.present?
            present project, with: Project::Entity
          else
            error!({:error_code => ErrorList::NOT_FOUND, :error_message => "Could not find project"}, 422)
          end
        end

        desc "Create Project"
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
              id: project.id,
              status: 'ok'
            }
          else
            error!({:error_code => ErrorList::NOT_CREATED, :error_message => project.errors.full_messages.to_s}, 422)
          end
        end

        desc "Update Project"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :project_id, type: Integer
          optional :title, type: String
          optional :description, type: String
          optional :deadline, type: Date
          optional :percent_done, type: Integer
        end
        put :update do
          project = current_user.projects.where(:id => params[:project_id]).first
          if project.present?
            if project.update_params(params)
              status(201)
              {
                status: 'ok'
              }
            else
              error!({:error_code => ErrorList::NOT_UPDATED, :error_message => project.errors.full_messages.to_s}, 422)
            end
          else
            error!({:error_code => ErrorList::NOT_FOUND, :error_message => "Could not find project"}, 422)
          end
        end

        desc "Delete Project"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :project_id, type: Integer
        end
        delete :delete do
          project = current_user.projects.find_by_id(params[:project_id])
          return error!({:error_code => ErrorList::NOT_AUTHORIZED, :error_message => "Unauthorized"}, 401) unless project
          if project.destroy
            status(200)
            {
              status: 'ok'
            }
          else
            error!({:error_code => ErrorList::NOT_DESTROYED, :error_message => project.errors.full_messages.to_s}, 422)
          end
        end

      end

    end
  end
end
