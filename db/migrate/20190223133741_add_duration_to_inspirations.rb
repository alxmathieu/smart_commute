class AddDurationToInspirations < ActiveRecord::Migration[5.2]
  def change
    add_column :inspirations, :duration, :integer
  end
end
