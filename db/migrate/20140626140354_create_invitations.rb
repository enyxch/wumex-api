class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.text :notes
      t.integer :project_id
      t.integer :user_id
      t.integer :inviting_user_id
      
      t.timestamps
    end
  end
end
