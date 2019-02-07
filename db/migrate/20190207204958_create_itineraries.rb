class CreateItineraries < ActiveRecord::Migration[5.2]
  def change
    create_table :itineraries do |t|
      t.string :start_point
      t.string :end_point
      t.integer :duration

      t.timestamps
    end
  end
end
