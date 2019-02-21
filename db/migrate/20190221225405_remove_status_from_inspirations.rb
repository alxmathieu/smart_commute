class RemoveStatusFromInspirations < ActiveRecord::Migration[5.2]
  def change
    remove_column :inspirations, :status
  end
end
