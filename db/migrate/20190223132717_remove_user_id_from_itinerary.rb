class RemoveUserIdFromItinerary < ActiveRecord::Migration[5.2]
  def change
    remove_column :itineraries, :user_id
  end
end
