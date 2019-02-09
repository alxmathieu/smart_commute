class ItinerariesController < ApplicationController



  def new
    @itinerary = Itinerary.new
  end

  def create
    @last_itinerary = Itinerary.where(user_id: itinerary_params["user_id"]).last
    Itinerary.destroy(@last_itinerary.id)
    @itinerary = Itinerary.new(itinerary_params)
    unless @itinerary.save
      raise
    end
  end

  private

  def itinerary_params
    params.require(:itinerary).permit(:user_id, :start_point, :end_point, :duration)
  end

end
