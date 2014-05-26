class Project < ActiveRecord::Base

  has_many :notes
  has_many :tasks
  has_many :documents
  has_and_belongs_to_many :users

end
