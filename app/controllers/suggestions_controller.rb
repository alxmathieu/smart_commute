class SuggestionsController < ApplicationController
  skip_before_action :authenticate_user!, :only => :update


  def update
    suggestion = Suggestion.find(params[:id])
    suggestion.status = "seen"
    suggestion.save!

    respond_to do |format|
      format.html {redirect_to suggestion.inspiration.url}
      format.json {redirect_to suggestion.inspiration.url}
    end
  end

  def add_to_watchlist
    suggestion = Suggestion.find(params[:id])
    suggestion.status = "watchlist"
    suggestion.save!
  end


private

  def itinerary_params
    params.require(:suggestion).permit(:itinerary_id, :inspiration_id, :user_id, :status)
  end


end
