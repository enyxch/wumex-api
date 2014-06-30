class Contact < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :my_contact, :class_name => 'User', :foreign_key => 'contact_id'
  
end
