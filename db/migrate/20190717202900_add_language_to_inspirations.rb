class AddLanguageToInspirations < ActiveRecord::Migration[5.2]
  def change
    add_column :inspirations, :language, :string
  end
end
