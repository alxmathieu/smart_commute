class CreateSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :suggestions do |t|
      t.string :status
      t.references :itinerary, foreign_key: true
      t.references :inspiration, foreign_key: true

      t.timestamps
    end
  end
end
