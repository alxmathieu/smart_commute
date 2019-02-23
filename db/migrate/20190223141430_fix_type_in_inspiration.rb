class FixTypeInInspiration < ActiveRecord::Migration[5.2]
  def change
    rename_column :inspirations, :type, :inspiration_type
  end
end
