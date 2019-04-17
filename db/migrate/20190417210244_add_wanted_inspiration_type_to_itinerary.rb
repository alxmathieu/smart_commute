class AddWantedInspirationTypeToItinerary < ActiveRecord::Migration[5.2]
  def change
    add_column :itineraries, :wanted_inspiration_type, :string
  end
end
