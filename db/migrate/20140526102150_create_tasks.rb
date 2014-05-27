class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.date :deadline
      t.string :task_type
      t.string :priority
      t.string :state
      t.string :time_spent
      t.string :time_estimated
      t.integer :depends_on_task_id
      t.integer :label_id
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end

    add_index :tasks, :project_id
    add_index :tasks, :label_id
    add_index :tasks, :user_id

  end
end
