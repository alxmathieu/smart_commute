class ItinerariesController < ApplicationController



  def new
    @itinerary = Itinerary.new
  end

  def create
    @last_itinerary = Itinerary.where(user_id: itinerary_params["user_id"]).last
    Itinerary.destroy(@last_itinerary.id) unless @last_itinerary.nil?
    @itinerary = Itinerary.new(itinerary_params)
    if @itinerary.save
      redirect_to itinerary_path(@itinerary)
    end

  end

  def show
    @itinerary = Itinerary.find(params[:id])
  end

  private

  def build_link_for_google(itinerary)
    api_key = ENV['MAPS_API_KEY']
    origin = itinerary.start_point.gsub(' ','+')
    destination = itinerary.end_point.gsub(' ','+')
    link = "https://maps.googleapis.com/maps/api/directions/json?origin=#{origin}&destination=#{destination}&mode=transit&key=#{api_key}"
  end

  def itinerary_params
    params.require(:itinerary).permit(:user_id, :start_point, :end_point, :duration)
  end

end
