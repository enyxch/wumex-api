class CreateLabelsTasksJoinTable < ActiveRecord::Migration
  def change
    create_table :labels_tasks, id: false do |t|
      t.integer :label_id
      t.integer :task_id      
    end
  end
end
