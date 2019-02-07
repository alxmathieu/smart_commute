class AddItineraryReferenceToInspirations < ActiveRecord::Migration[5.2]
  def change
    add_reference :inspirations, :itinerary, foreign_key: true

  end
end
