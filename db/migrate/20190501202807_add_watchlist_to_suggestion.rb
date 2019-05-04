class AddWatchlistToSuggestion < ActiveRecord::Migration[5.2]
  def change
    add_column :suggestions, :watchlisted, :boolean, default: false
  end
end
