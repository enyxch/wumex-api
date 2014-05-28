module API
  module V1
    class Labels < Grape::API
      include API::V1::Defaults
      include API::V1::Authorization
      helpers API::V1::ApiHelpers
      
      resource :labels do
        desc "Authorize User can create Labels"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :name, type: String
          optional :project_id, type: Integer
          optional :task_id, type: Integer
        end
        post :create do
          return error!({:error => '4014', :error_message => "Project or Task can't be blank"}, 401) unless (params[:project_id] or params[:task_id])
          return error!({:error => '4014', :error_message => "Input Project or Task at a time"}, 401) if (params[:project_id] and params[:task_id])
          
          task = project = label = nil
          if params[:project_id]
            project = current_user.projects.find_by_id(params[:project_id])
            return error!({:error => '4012', :error_message => "Unauthorized project"}, 401) unless project
            label = project.labels.create(:name => params[:name])
          end
          
          if params[:task_id]
            task = Task.where("id=? and user_id=?", params[:task_id], current_user.id).first
            return error!({:error => '4013', :error_message => "Unauthorized task"}, 401) unless task
            label = task.labels.create(:name => params[:name])
          end

          if label.persisted?
            status(201)
            {
              status: 'ok'
            }
          else
            error!({:error => '4222', :error_message => label.errors.full_messages.to_s}, 422)
          end
        end
        
        desc "Authorize User can delete Labels"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :label_id, type: Integer
        end
        delete :delete do
          label = Label.find_by_id(params[:label_id])
          return error!({:error => '4043', :error_message => "Label not found"}, 404) unless label
          users=[]
          users << (label.project.try(:users) || []) << (label.tasks.select{|task| task if task.user_id.present? }.map(&:user)  || [])
          return error!({:error => '4043', :error_message => "Label not found"}, 404) unless users.flatten.include? current_user
          
          if label.destroy
            status(200)
            {
              status: 'ok'
            }
          else
            error!({:error => '4222', :error_message => label.errors.full_messages.to_s}, 422)
          end
        end
        
      end
    
    end
  end
end
