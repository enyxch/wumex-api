class Note < ActiveRecord::Base

  belongs_to :project
  belongs_to :task
  belongs_to :meeting
  
  class << self
    def create_note(params)
      self.create({ :name => params[:name],
        :body => params[:description],
        :project_id => params[:project_id],
        :task_id => params[:task_id]
      })
    end
  end
  
  def update_note(params)
    update_attributes({ :name => params[:name],
      :body => params[:description],
      :project_id => params[:project_id],
      :task_id => params[:task_id]
    })
  end
  
end
