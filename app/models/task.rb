class Task < ActiveRecord::Base

  belongs_to :project
  belongs_to :user

  has_and_belongs_to_many :labels
  has_many :documents

end
