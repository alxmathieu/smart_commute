require 'open-uri'
require 'nokogiri'

class ItinerariesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:new, :create, :show]

  def new
    @itinerary = Itinerary.new
    @inspiration_type = Inspiration.pluck(:inspiration_type).unshift("all").uniq!
  end

  def create
    # destroy last itinerary for the user
    # @last_itinerary = Itinerary.where(user_id: itinerary_params["user_id"]).last
    # Itinerary.destroy(@last_itinerary.id) unless @last_itinerary.nil?
    # create new itinerary
    @itinerary = Itinerary.new(itinerary_params)
    # retrieve duration and set duration
    if @itinerary.duration
      @itinerary.save
      redirect_to itinerary_path(@itinerary)
    elsif @itinerary.start_point == "" || @itinerary.end_point == ""
      flash[:alert] = 'Please enter start & end points or duration'
      render :new
    else
      url = build_google_maps_url(@itinerary)
      set_duration_for_itinerary(@itinerary, url)
      @itinerary.save
      redirect_to itinerary_path(@itinerary)
    end
    # save itinerary
    # if @itinerary.save
    #   redirect_to itinerary_path(@itinerary)
    # else
    #   render :new
    # end

  end

  def show
    @itinerary = Itinerary.find(params[:id])
    # Récupérer toutes les inspirations qui durent same duration
    eligible_inspirations = Inspiration.all.select {|inspiration|
      inspiration.duration < @itinerary.duration  &&
      inspiration.duration > @itinerary.duration * 0.75 &&
      if @itinerary.wanted_inspiration_type != "all"
        inspiration.inspiration_type == @itinerary.wanted_inspiration_type
        # @itinerary.wanted_inspiration_type renvoie toujours nil. On n'arrive pas à set le field dans le simple form ??
      else
        true
      end
    }
    # N'en prendre que 4 et les passer à la vue
    if eligible_inspirations.count < 8
      elected_inspirations = eligible_inspirations
    else
      elected_inspirations = eligible_inspirations.sample(8)
    end

    suggestions = create_suggestions_from_inspirations(elected_inspirations)
    suggestions.reject!{|suggestion| suggestion.nil?}

    @article_suggestions = suggestions.select{|suggestion| suggestion.inspiration.inspiration_type == 'article'}
    @video_suggestions = suggestions.select{|suggestion| suggestion.inspiration.inspiration_type == 'video'}
    @podcast_suggestions = suggestions.select{|suggestion| suggestion.inspiration.inspiration_type == 'podcast'}

  end

  private

  def create_suggestions_from_inspirations(inspirations_array)
    inspirations_array.map{|elected_inspiration|
      if current_user.nil?
        if Suggestion.where(inspiration: elected_inspiration, itinerary: @itinerary).empty?
          Suggestion.create(
            inspiration: elected_inspiration,
            itinerary: @itinerary,
            status: 'suggested'
            )
        else
          Suggestion.where(inspiration: elected_inspiration, itinerary: @itinerary).first
        end
      elsif current_user.already_suggested_inspirations.include?(elected_inspiration)
        all_itineraries_for_current_user = Itinerary.where(user: current_user)
        Suggestion.where(
          inspiration: elected_inspiration,
          itinerary: all_itineraries_for_current_user,
          status: "suggested"
        ).first
      else
        Suggestion.create(
          inspiration: elected_inspiration,
          itinerary: @itinerary,
          status: 'suggested'
          )
      end
    }
  end

  def build_google_maps_url(itinerary)
    api_key = ENV['MAPS_API_KEY']
    # Pour supprimer les espaces et rendre le point de départ/arrivée url-compliant
    origin = itinerary.start_point.gsub(' ','+')
    destination = itinerary.end_point.gsub(' ','+')
    url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{origin}&destination=#{destination}&mode=transit&key=#{api_key}"
  end

  # def retrieve_duration_from_url(url)
  #   ascii_url = URI.escape(url)
  #   data = JSON.parse(open(ascii_url).read)
  #   routes = data["routes"].first
  #   legs = routes["legs"].first
  #   duration = legs["duration"]["text"]
  # end

  def set_duration_for_itinerary(itinerary, url)
    ascii_url = URI.escape(url)
    data = JSON.parse(open(ascii_url).read)
    begin
      routes = data["routes"].first
      legs = routes["legs"].first
      duration = legs["duration"]["value"]
      itinerary.duration = duration / 60
      itinerary.save
    rescue
      itinerary.duration = 0
      itinerary.save
    end

  end

  def itinerary_params
    params.require(:itinerary).permit(:user_id, :start_point, :end_point, :duration, :wanted_inspiration_type)
  end

end
