class Label < ActiveRecord::Base

  belongs_to :project

  has_and_belongs_to_many :tasks

  def update_params(params)
    update_attributes({ :name => params[:name],
      :project_id => params[:project_id],
      :position => params[:position]
    })
  end


end
