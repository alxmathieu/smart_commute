class ItinerariesController < ApplicationController



  def new
    @itinerary = Itinerary.new
  end

  def create
    Itinerary.destroy(@last_itinerary.id)  if Itinerary.where(user_id: itinerary_params["user_id"]).last.nil?
    @itinerary = Itinerary.new(itinerary_params)
    @itinerary.save
  end

  private

  def itinerary_params
    params.require(:itinerary).permit(:user_id, :start_point, :end_point, :duration)
  end

end
