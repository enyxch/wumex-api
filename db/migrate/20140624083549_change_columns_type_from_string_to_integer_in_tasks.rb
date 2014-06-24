class ChangeColumnsTypeFromStringToIntegerInTasks < ActiveRecord::Migration
  def change
    change_column :tasks, :time_spent, 'integer USING CAST(time_spent AS integer)'
    change_column :tasks, :time_estimated, 'integer USING CAST(time_estimated AS integer)'
  end
end
