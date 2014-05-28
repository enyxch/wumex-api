module API
  module V1
    class Documents < Grape::API
      include API::V1::Defaults
      include API::V1::Authorization
      helpers API::V1::ApiHelpers
      
      resource :documents do
        desc "Authorize User can create Documents"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :name, type: String
          optional :document_type, type: String
          optional :upload_url, type: String
          optional :project_id, type: Integer
          optional :task_id, type: Integer
        end
        post :create do
          task = project = nil
          
          if params[:project_id]
            project = current_user.projects.find_by_id(params[:project_id])
            return error!({:error => '4012', :error_message => "Unauthorized project"}, 401) unless project
          end
          
          if params[:task_id]
            task = Task.where("id=? and user_id=?", params[:task_id], current_user.id).first
            return error!({:error => '4013', :error_message => "Unauthorized task"}, 401) unless task
          end
          
          return error!({:error => '4014', :error_message => "Project or Task can't be blank"}, 401) unless (project or task)
          document = Document.create_document(params, current_user, project, task)
          if document.persisted?
            status(201)
            {
              status: 'ok'
            }
          else
            error!({:error => '4221', :error_message => document.errors.full_messages.to_s}, 422)
          end
        end
        
        desc "Authorize User can delete Documents"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :document_id, type: Integer
        end
        delete :delete do
          document = Document.find_by_id(params[:document_id])
          return error!({:error => '4042', :error_message => "Document not found"}, 401) unless document
          users=[]
          users << (document.project.try(:users) || []) << (document.task.try(:user) || [])
          return error!({:error => '4042', :error_message => "Document not found"}, 401) unless users.flatten.include? current_user
          
          if document.destroy
            status(200)
            {
              status: 'ok'
            }
          else
            error!({:error => '4221', :error_message => document.errors.full_messages.to_s}, 422)
          end
        end
        
      end 
      
    end
  end
end
