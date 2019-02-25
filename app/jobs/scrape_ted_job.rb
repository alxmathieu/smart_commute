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
    duration.each do |interval|
      ted_url = "https://www.ted.com/talks?sort=jaw-dropping&duration=#{interval}"
      scrape_ted_names(ted_url)
    end
  end


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
    end
# pas du tout de check de "est-ce que ca existe" pour les inspirations, il faut checker si le nom est déjà pris.
# -> ajouter des validations sur les modèles

  end


  def build_ted_videos_urls(array)
    array.map! {|link|"http://ted.com#{link}"}
  end

end
