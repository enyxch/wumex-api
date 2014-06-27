module API
  module V1
    class Invitations < Grape::API
      include API::V1::Defaults
      include API::V1::Authorization
      helpers API::V1::ApiHelpers

      resource :invitations do
        desc "Authorize User can create Invitations"
        params do
          requires :token, type: String, desc: "Authorization"
          optional :notes, type: String
          requires :project_id, type: Integer
          requires :user_id, type: Integer
        end
        post :create do
          project = current_user.projects.find_by_id(params[:project_id])
          return error!({:error_code => ErrorList::PROJECT_NOT_FOUND, :error_message => "Could not find project"}, 404) unless project
          
          user = User.find_by_id(params[:user_id])
          return error!({:error_code => ErrorList::USER_NOT_FOUND, :error_message => "Could not find user"}, 404) unless user
          
          invitation = Invitation.create_invitation(params, current_user.id)
          if invitation.persisted?
            status(201)
            {
              id: invitation.id,
              status: 'ok'
            }
          else
            error!({:error_code => ErrorList::INVITATION_NOT_CREATED, :error_message => invitation.errors.full_messages.to_s}, 422)
          end
        end
        
        desc "Accept Invitations"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :invitation_id, type: Integer
        end
        get :accept_invitation do
          invitation = current_user.invitations.get_invitation(params[:invitation_id]).first
          return error!({:error_code => ErrorList::INVITATION_NOT_FOUND, :error_message => "Could not find invitation"}, 404) unless invitation
          
          project = Project.get_project(invitation.project_id).first
          project.users << current_user unless project.users.include?(current_user)
          
          if project.save
            if invitation.destroy
              status(200)
              {
                status: 'ok'
              }
            else
              error!({:error_code => ErrorList::INVITATION_NOT_DESTROYED, :error_message => invitation.errors.full_messages.to_s}, 422)
            end
          else
            error!({:error_code => ErrorList::PROJECT_NOT_UPDATED, :error_message => project.errors.full_messages.to_s}, 422)
          end
        end
        
      end

    end
  end
end
