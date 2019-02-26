require 'open-uri'
require 'nokogiri'

class ScrapeTedJob < ApplicationJob
  queue_as :default

  def perform(*args)
    create_ted_inspirations
    # retrieve urls for one duration
    # for each, check if video is already in existing inspirations
    # create new one if not
  end

  def create_ted_inspirations
    duration = ['0-6', '6-12', '12-18', "18%2B"]
    pages = [1...10]
    duration.each do |interval|
      pages.each do |page|
        ted_url = "https://www.ted.com/talks?sort=jaw-dropping&duration=#{interval}&page=#{page}"
        scrape_ted_names(ted_url)
      end
    end
  end

  # def inspiration_already_exists?(inspiration)
  #   all_inspirations = Inspiration.all
  #   result = false
  #   unless all_inspirations.empty?
  #       all_inspirations.each do |existing_inspiration|
  #         if existing_inspiration.name == inspiration.name
  #           result = true
  #           break
  #         end
  #       end
  #   end
  #   result
  # end

  def scrape_ted_names(url)
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search('.talk-link').each do |element|
      video_duration = element.search('.thumb__duration').text.strip
      video_name = element.search('.h9.m5 a').text.strip
      video_link = "http://ted.com#{element.search('.h9.m5 a').attribute('href').value}"
      Inspiration.create(
        inspiration_type: 'video',
        source: 'ted',
        duration: video_duration,
        name: video_name,
        url: video_link
        )
      # new_inspiration = Inspiration.new(
      #   inspiration_type: 'video',
      #   source: 'ted',
      #   duration: video_duration,
      #   name: video_name,
      #   url: video_link
      #   )
      # new_inspiration.save unless inspiration_already_exists?(new_inspiration)
    end
  end


  def build_ted_videos_urls(array)
    array.map! {|link|"http://ted.com#{link}"}
  end

end
