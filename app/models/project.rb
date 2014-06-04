class Project < ActiveRecord::Base

  include ProjectRepresenters

  has_and_belongs_to_many :users

  has_many :notes
  has_many :tasks
  has_many :documents
  has_many :meetings
  has_many :labels

  class << self
    def create_project(user, params)
      user.projects.create({ :title => params[:title],
        :description => params[:description],
        :deadline => params[:deadline],
        :percent_done => params[:percent_done]
      })
    end
  end

end
