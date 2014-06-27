class Invitation < ActiveRecord::Base

  belongs_to :user
  belongs_to :inviting_user, :class_name => 'User', :foreign_key => 'inviting_user_id'
  
  scope :get_invitation, ->(id) { where(:id => id) }
  
  class << self
    def create_invitation(params, inviting_user_id)
      self.create({ :notes => params[:notes],
        :project_id => params[:project_id],
        :user_id => params[:user_id],
        :inviting_user_id => inviting_user_id
      })
    end
  end
  
  
end
