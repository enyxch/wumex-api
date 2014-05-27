class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :name
      t.text :body
      t.integer :project_id
      t.integer :task_id
      t.integer :meeting_id

      t.timestamps
    end

  add_index :notes, :project_id
  add_index :notes, :task_id
  add_index :notes, :meeting_id

  end
end
