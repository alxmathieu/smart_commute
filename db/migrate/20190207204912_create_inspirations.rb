class CreateInspirations < ActiveRecord::Migration[5.2]
  def change
    create_table :inspirations do |t|
      t.string :type
      t.string :status

      t.timestamps
    end
  end
end
