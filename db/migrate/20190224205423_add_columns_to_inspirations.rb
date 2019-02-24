class AddColumnsToInspirations < ActiveRecord::Migration[5.2]
  def change

    add_column :inspirations, :url, :string
    add_column :inspirations, :name, :string
  end
end
