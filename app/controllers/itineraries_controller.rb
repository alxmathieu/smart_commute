require 'open-uri'
require 'nokogiri'

class ItinerariesController < ApplicationController

  def new
    @itinerary = Itinerary.new
  end

  def create
    # destroy last itinerary for the user
    @last_itinerary = Itinerary.where(user_id: itinerary_params["user_id"]).last
    Itinerary.destroy(@last_itinerary.id) unless @last_itinerary.nil?
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
    # Construire le lien pour l'api google
    url = build_google_maps_url(@itinerary)
    # Récupérer la data du json google et la duration
    @duration_text = retrieve_duration_from_url(url)
    # Create 4 inspirations
    @inspiration1 = Inspiration.new
    @inspiration2 = Inspiration.new
    @inspiration3 = Inspiration.new
    @inspiration4 = Inspiration.new
    inspirations = [@inspiration1, @inspiration2, @inspiration3, @inspiration4]
    # build ted url
    ted_url = build_ted_url(@itinerary.duration)
    @ted_talks = scrape_ted_links(ted_url).map! {|link|"http://ted.com#{link}"}
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
