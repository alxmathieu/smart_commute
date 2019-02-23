class AddSourceToInspirations < ActiveRecord::Migration[5.2]
  def change
    add_column :inspirations, :source, :string
  end
end
