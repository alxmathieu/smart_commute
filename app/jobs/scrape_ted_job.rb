require 'open-uri'
require 'nokogiri'

class ScrapeTedJob < ApplicationJob
  queue_as :default

  def perform(*args)
    create_ted_inspirations
  end

  def create_ted_inspirations
    duration = ['0-6', '6-12', '12-18', "18%2B"]
    pages = [1, 2, 3, 4, 5, 6]
    duration.each do |interval|
      pages.each do |page|
        ted_url = "https://www.ted.com/talks?sort=popular&duration=#{interval}&page=#{page}"
        scrape_ted_names(ted_url)
      end
    end
  end

  def scrape_ted_names(url)
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search('.talk-link').each do |element|
      video_duration = element.search('.thumb__duration').text.strip.to_i
      video_name = element.search('.h9.m5 a').text.strip
      video_link = "http://ted.com#{element.search('.h9.m5 a').attribute('href').value}"
      Inspiration.create(
        inspiration_type: 'video',
        source: 'Ted',
        duration: video_duration + 1, # to round to higher minute
        name: video_name,
        url: video_link
        )
    end
  end


  # def build_ted_videos_urls(array)
  #   array.map! {|link|"http://ted.com#{link}"}
  # end

end
