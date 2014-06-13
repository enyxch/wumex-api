class Task < ActiveRecord::Base

  belongs_to :project
  belongs_to :user

  has_and_belongs_to_many :labels
  has_many :documents

  class << self
    def create_task(params, user_id, project)
      project.tasks.create({ :name => params[:name],
        :description => params[:description],
        :start_date => params[:start_date],
        :end_date => params[:end_date],
        :task_type => params[:task_type],
        :priority => params[:priority],
        :state => params[:state],
        :time_spent => params[:time_spent],
        :time_estimated => params[:time_estimated],
        :depends_on_task_id => params[:depends_on_task_id],
        :label_id => params[:label_id],
        :user_id => user_id
      })
    end
  end

  def update_params(params)
    update_attributes({ :name => params[:name],
      :description => params[:description],
      :start_date => params[:start_date],
      :end_date => params[:end_date],
      :task_type => params[:task_type],
      :priority => params[:priority],
      :state => params[:state],
      :time_spent => params[:time_spent],
      :time_estimated => params[:time_estimated],
      :depends_on_task_id => params[:depends_on_task_id],
      :label_id => params[:label_id]
    })
  end

end
