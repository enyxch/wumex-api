class Document < ActiveRecord::Base

  belongs_to :project
  belongs_to :task
  belongs_to :meeting
  
  class << self
    def create_document(params, current_user, project, task)
      self.create({ :name => params[:name],
        :document_type => params[:document_type],
        :upload_url => params[:upload_url],
        :project_id => project.try(:id),
        :task_id => task.try(:id)
      })
    end
  end
  
end
