class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.date :deadline
      t.integer :percent_done

      t.timestamps
    end
  end
end
