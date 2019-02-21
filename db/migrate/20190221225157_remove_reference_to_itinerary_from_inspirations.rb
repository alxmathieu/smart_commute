class RemoveReferenceToItineraryFromInspirations < ActiveRecord::Migration[5.2]
  def change
    remove_reference(:inspirations, :itinerary, index: true, foreign_key: true)
  end
end
