class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.string :document_type
      t.string :upload_url
      t.integer :project_id
      t.integer :task_id

      t.timestamps
    end

  add_index :documents, :project_id
  add_index :documents, :task_id

  end
end
