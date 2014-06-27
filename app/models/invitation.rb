class Invitation < ActiveRecord::Base

  belongs_to :user
  belongs_to :inviting_user, :class_name => 'User', :foreign_key => 'inviting_user_id'
  
end
