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
    @suggestion = Suggestion.find(params[:id])
    @suggestion.watchlisted = true
    #suggestion.update(watchlisted: true)
    if @suggestion.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js  # <-- will render `app/views/reviews/add_to_watchlist.js.erb`
      end
    else
      respond_to do |format|
        format.html { render 'root' }
        format.js  # <-- idem
      end
    end
  end

  def remove_from_watchlist
    @suggestion = Suggestion.find(params[:id])
    @suggestion.watchlisted = false
    #suggestion.update(watchlisted: true)
    if @suggestion.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js  # <-- will render `app/views/reviews/add_to_watchlist.js.erb`
      end
    else
      respond_to do |format|
        format.html { render 'root' }
        format.js  # <-- idem
      end
    end
  end


private

  def itinerary_params
    params.require(:suggestion).permit(:itinerary_id, :inspiration_id, :user_id, :status, :watchlisted)
  end


end
