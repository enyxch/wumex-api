module API
  module V1
    class Notes < Grape::API
      include API::V1::Defaults
      include API::V1::Authorization
      helpers API::V1::ApiHelpers

      resource :notes do
        desc "List Notes"
        params do
          requires :token, type: String, desc: "Authorization"
          optional :project_id, type: Integer
          optional :task_id, type: Integer
        end
        get do
          return error!({:error_code => ErrorList::NO_PROJECT_OR_TASK, :error_message => "Project or Task can't be blank"}, 401) unless (params[:project_id] or params[:task_id])
          
          task = project = nil
          if params[:project_id]
            project = current_user.projects.find_by_id(params[:project_id])
            return error!({:error_code => ErrorList::PROJECT_NOT_FOUND, :error_message => "Could not find project"}, 404) unless project
            notes = project.notes
          end

          if params[:task_id]
            task = Task.where("id=? and user_id=?", params[:task_id], current_user.id).first
            return error!({:error_code => ErrorList::TASK_NOT_FOUND, :error_message => "Could not find task"}, 404) unless task
            notes = task.notes
          end
          
          notes
        end
        
        desc "Authorize User can create Notes"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :name, type: String
          optional :description, type: String
          optional :project_id, type: Integer
          optional :task_id, type: Integer
        end
        post :create do
          return error!({:error_code => ErrorList::NO_PROJECT_OR_TASK, :error_message => "Project or Task can't be blank"}, 403) unless (params[:project_id] or params[:task_id])

          task = project = nil
          if params[:project_id]
            project = current_user.projects.find_by_id(params[:project_id])
            return error!({:error_code => ErrorList::NOT_AUTHORIZED, :error_message => "Unauthorized project"}, 401) unless project
          end

          if params[:task_id]
            task = Task.where("id=? and user_id=?", params[:task_id], current_user.id).first
            return error!({:error_code => ErrorList::NOT_AUTHORIZED, :error_message => "Unauthorized task"}, 401) unless task
          end

          note = Note.create_note(params)
          if note.persisted?
            status(201)
            {
              id: note.id,
              status: 'ok'
            }
          else
            error!({:error_code => ErrorList::NOTE_NOT_CREATED, :error_message => note.errors.full_messages.to_s}, 422)
          end
        end
        
        desc "Authorize User can update Notes"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :note_id, type: Integer
          requires :name, type: String
          optional :description, type: String
          optional :project_id, type: Integer
          optional :task_id, type: Integer
        end
        put :update do
          return error!({:error_code => ErrorList::NO_PROJECT_OR_TASK, :error_message => "Project or Task can't be blank"}, 403) unless (params[:project_id] or params[:task_id])
          
          note = Note.find_by_id(params[:note_id])
          return error!({:error_code => ErrorList::NOTE_NOT_FOUND, :error_message => "Note not found"}, 404) unless note
          
          if note.update_note(params)
            status(201)
            {
              id: note.id,
              status: 'ok'
            }
          else
            error!({:error_code => ErrorList::NOTE_NOT_UPDATED, :error_message => note.errors.full_messages.to_s}, 422)
          end
        end
        
        desc "Authorize User can delete Notes"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :note_id, type: Integer
        end
        delete :delete do
          note = Note.find_by_id(params[:note_id])
          return error!({:error_code => ErrorList::NOTE_NOT_FOUND, :error_message => "Note not found"}, 404) unless note
          users=[]
          users << (note.project.try(:users) || []) << (note.task.try(:user) || [])
          return error!({:error_code => ErrorList::NOT_AUTHORIZED, :error_message => "Unauthorized note"}, 401) unless users.flatten.include? current_user

          if note.destroy
            status(200)
            {
              status: 'ok'
            }
          else
            error!({:error_code => ErrorList::NOTE_NOT_DESTROYED, :error_message => note.errors.full_messages.to_s}, 422)
          end
        end
        
      end

    end
  end
end
