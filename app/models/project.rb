class Project < ActiveRecord::Base

  has_and_belongs_to_many :users

  has_many :notes
  has_many :tasks
  has_many :documents
  has_many :meetings
  has_many :labels

end
