class AddPositionToLabels < ActiveRecord::Migration
  def change
    add_column :labels, :position, :integer
  end
end
