module API
  module V1
    class Tasks < Grape::API
      include API::V1::Defaults
      include API::V1::Authorization
      helpers API::V1::ApiHelpers

      resource :tasks do
        desc "List Tasks"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :project_id, type: Integer
        end
        get do
          project = current_user.projects.find_by_id(params[:project_id])
          return error!({:error_code => ErrorList::PROJECT_NOT_FOUND, :error_message => "Could not find project"}, 404) unless project
          project.tasks
        end

        desc "Authorize User can create Tasks"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :name, type: String
          requires :project_id, type: Integer
          optional :description, type: String
          optional :start_date, type: Date
          optional :end_date, type: Date
          optional :task_type, type: String
          optional :priority, type: String
          optional :state, type: String
          optional :time_spent, type: String
          optional :time_estimated, type: String
          optional :depends_on_task_id, type: String
          optional :label_id, type: Integer
        end
        post :create do
          project = current_user.projects.find_by_id(params[:project_id])
          return error!({:error_code => ErrorList::PROJECT_NOT_FOUND, :error_message => "Could not find project"}, 404) unless project
          task = Task.create_task(params, current_user.id, project)

          if task.persisted?
            status(201)
            {
              status: 'ok'
            }
          else
            error!({:error_code => ErrorList::TASK_NOT_CREATED, :error_message => task.errors.full_messages.to_s}, 422)
          end
        end

        desc "Update Task"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :task_id, type: Integer
          requires :name, type: String
          optional :description, type: String
          optional :start_date, type: Date
          optional :end_date, type: Date
          optional :task_type, type: String
          optional :priority, type: String
          optional :state, type: String
          optional :time_spent, type: String
          optional :time_estimated, type: String
          optional :depends_on_task_id, type: String
          optional :label_id, type: Integer
        end
        put :update do
          task = Task.find_by_id(params[:task_id])
          if task.present?
            if task.update_params(params)
              status(201)
              {
                status: 'ok'
              }
            else
              error!({:error_code => ErrorList::TASK_NOT_UPDATED, :error_message => task.errors.full_messages.to_s}, 422)
            end
          else
            error!({:error_code => ErrorList::TASK_NOT_FOUND, :error_message => "Could not find task"}, 422)
          end
        end

        desc "Authorize User can delete Tasks"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :task_id, type: Integer
        end
        delete :delete do
          task = Task.find_by_id(params[:task_id])
          return error!({:error_code => ErrorList::TASK_NOT_FOUND, :error_message => "Could not find task"}, 404) unless task
          users=[]
          users << (task.project.try(:users) || [])
          return error!({:error_code => ErrorList::TASK_NOT_FOUND, :error_message => "Could not find task"}, 404) unless users.flatten.include? current_user

          if task.destroy
            status(200)
            {
              status: 'ok'
            }
          else
            error!({:error =>ErrorList::TASK_NOT_DESTROYED, :error_message => task.errors.full_messages.to_s}, 422)
          end
        end

      end

    end
  end
end
