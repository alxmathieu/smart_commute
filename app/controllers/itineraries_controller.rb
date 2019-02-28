require 'open-uri'
require 'nokogiri'

class ItinerariesController < ApplicationController

  def new
    @itinerary = Itinerary.new
  end

  def create
    # destroy last itinerary for the user
    # @last_itinerary = Itinerary.where(user_id: itinerary_params["user_id"]).last
    # Itinerary.destroy(@last_itinerary.id) unless @last_itinerary.nil?

    # create new itinerary
    @itinerary = Itinerary.new(itinerary_params)
    # retrieve duration and set duration
    url = build_google_maps_url(@itinerary)
    set_duration_for_itinerary(@itinerary, url)
    # save itinerary
    if @itinerary.save
      redirect_to itinerary_path(@itinerary)
    end

  end

  def show
    @itinerary = Itinerary.find(params[:id])
    @duration_text = @itinerary.duration_in_minutes
    # Récupérer toutes les inspirations qui durent same duration
    eligible_inspirations = Inspiration.all.select {|inspiration|
      inspiration.duration < @duration_text  &&
      inspiration.duration > @duration_text / 2
    }
    # N'en prendre que 4 et les passer à la vue
    if eligible_inspirations.count < 4
      elected_inspirations = eligible_inspirations
    else
      elected_inspirations = eligible_inspirations.sample(4)
    end

    @suggestions = elected_inspirations.map{|elected_inspiration|
      Suggestion.create(
        inspiration: elected_inspiration,
        itinerary: @itinerary
        )
    }


    # pb, on crée à chaque fois les suggestions. On ne va pas encore récupérer les suggestions qui
    # existent déjà mais n'ont pas été vues (avec le status)
  end

  private

  def build_google_maps_url(itinerary)
    api_key = ENV['MAPS_API_KEY']
    # Pour supprimer les espaces et rendre le point de départ/arrivée url-compliant
    origin = itinerary.start_point.gsub(' ','+')
    destination = itinerary.end_point.gsub(' ','+')
    url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{origin}&destination=#{destination}&mode=transit&key=#{api_key}"
  end

  def retrieve_duration_from_url(url)
    data = JSON.parse(open(url).read)
    routes = data["routes"].first
    legs = routes["legs"].first
    duration = legs["duration"]["text"]
  end

  def set_duration_for_itinerary(itinerary, url)
    data = JSON.parse(open(url).read)
    routes = data["routes"].first
    legs = routes["legs"].first
    duration = legs["duration"]["value"]
    itinerary.duration = duration
    itinerary.save
  end



  def itinerary_params
    params.require(:itinerary).permit(:user_id, :start_point, :end_point, :duration)
  end

end
