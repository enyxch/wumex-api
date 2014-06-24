module API
  module V1
    class Labels < Grape::API
      include API::V1::Defaults
      include API::V1::Authorization
      helpers API::V1::ApiHelpers

      resource :labels do
        desc "List Labels"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :project_id, type: Integer
        end
        get do
          project = current_user.projects.find_by_id(params[:project_id])
          return error!({:error_code => ErrorList::PROJECT_NOT_FOUND, :error_message => "Could not find project"}, 404) unless project
          project.labels
        end

        desc "Authorize User can create Labels"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :name, type: String
          requires :project_id, type: Integer
          optional :position, type: Integer
        end
        post :create do
          project = current_user.projects.find_by_id(params[:project_id])
          return error!({:error_code => ErrorList::NOT_AUTHORIZED, :error_message => "Unauthorized project"}, 401) unless project
          label = project.labels.create(:name => params[:name], :position => params[:position])

          if label.persisted?
            status(201)
            {
              id: label.id,
              status: 'ok'
            }
          else
            error!({:error_code => ErrorList::NOT_CREATED, :error_message => label.errors.full_messages.to_s}, 422)
          end
        end

        desc "Authorize User can delete Labels"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :label_id, type: Integer
        end
        delete :delete do
          label = Label.find_by_id(params[:label_id])
          return error!({:error_code => ErrorList::NOT_FOUND, :error_message => "Label not found"}, 404) unless label
          users=[]
          users << (label.project.try(:users) || [])
          return error!({:error_code => ErrorList::NOT_AUTHORIZED, :error_message => "Unauthorized label"}, 401) unless users.flatten.include? current_user

          if label.destroy
            status(200)
            {
              status: 'ok'
            }
          else
            error!({:error =>ErrorList::NOT_DESTROYED, :error_message => label.errors.full_messages.to_s}, 422)
          end
        end

        desc "Update Label"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :label_id, type: Integer
          requires :name, type: String
          requires :project_id, type: Integer
          optional :position, type: Integer
        end
        put :update do
          label = Label.find_by_id(params[:label_id])
          if label.present?
            if label.update_params(params)
              status(201)
              {
                status: 'ok'
              }
            else
              error!({:error_code => ErrorList::LABEL_NOT_UPDATED, :error_message => label.errors.full_messages.to_s}, 422)
            end
          else
            error!({:error_code => ErrorList::LABEL_NOT_FOUND, :error_message => "Could not find label"}, 422)
          end
        end

      end

    end
  end
end
