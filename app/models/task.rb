class Task < ActiveRecord::Base
  
  belongs_to :label
  belongs_to :project
  belongs_to :user
  has_many :documents
  
end
