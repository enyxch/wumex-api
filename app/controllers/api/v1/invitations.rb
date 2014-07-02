module API
  module V1
    class Invitations < Grape::API
      include API::V1::Defaults
      include API::V1::Authorization
      helpers API::V1::ApiHelpers

      resource :invitations do
        desc "List Invitations"
        params do
          requires :token, type: String, desc: "Authorization"
        end
        get :list_invitations do
          current_user.invitations
        end
      
        desc "Authorize User can send Project Invitations"
        params do
          requires :token, type: String, desc: "Authorization"
          optional :notes, type: String
          requires :project_id, type: Integer
          requires :user_id, type: Integer
        end
        post :project_invitation do
          project = current_user.projects.find_by_id(params[:project_id])
          return error!({:error_code => ErrorList::PROJECT_NOT_FOUND, :error_message => "Could not find project"}, 404) unless project
          
          user = User.find_by_id(params[:user_id])
          return error!({:error_code => ErrorList::USER_NOT_FOUND, :error_message => "Could not find user"}, 404) unless user
          
          invitation = Invitation.create_project_invitation(params, current_user.id)
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
        
        desc "Accept Project Invitations"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :invitation_id, type: Integer
        end
        put :accept_project_invitation do
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
        
        desc "Authorize User can send Contact Invitations"
        params do
          requires :token, type: String, desc: "Authorization"
          group :user_ids
        end
        post :contact_invitation do
          user_ids = eval(params[:user_ids])
          
          users = User.where(id: user_ids)
          not_found_user_ids = user_ids.select{|user_id| users.map(&:id).exclude?(user_id.to_i) }
          return error!({:error_code => ErrorList::USER_NOT_FOUND, :error_message => "Could not find users with following IDs #{not_found_user_ids}"}, 404) if not_found_user_ids.present?
          
          invitations = []
          users.each do |user|
            invitation = Invitation.create_contact_invitation(user.id, current_user.id)
            error!({:error_code => ErrorList::INVITATION_NOT_CREATED, :error_message => invitation.errors.full_messages.to_s}, 422) unless invitation.persisted?
            invitations << invitation.id
          end
          
          if invitations.present?
            status(200)
            { 
              invitations: invitations,
              status: 'ok'
            }
          end
        end
        
        desc "Decline Invitations"
        params do
          requires :token, type: String, desc: "Authorization"
          requires :invitation_id, type: Integer
        end
        delete :decline_invitation do
          invitation = current_user.invitations.get_invitation(params[:invitation_id]).first
          return error!({:error_code => ErrorList::INVITATION_NOT_FOUND, :error_message => "Could not find invitation"}, 404) unless invitation
          
          if invitation.destroy
            status(200)
            {
              status: 'ok'
            }
          else
            error!({:error_code => ErrorList::INVITATION_NOT_DESTROYED, :error_message => invitation.errors.full_messages.to_s}, 422)
          end
        end
        
      end

    end
  end
end
