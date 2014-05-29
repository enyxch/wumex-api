class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.integer :project_id

      t.timestamps
    end

  add_index :labels, :project_id

  end
end
