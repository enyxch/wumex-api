class Note < ActiveRecord::Base

  belongs_to :project
  belongs_to :task
  belongs_to :meeting

end
