class Note < ActiveRecord::Base
  
  belongs_to :meeting
  belongs_to :project
  belongs_to :task
  
end
