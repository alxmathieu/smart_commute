require 'open-uri'
require 'nokogiri'


class ScrapeBoomerangJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    create_boomerang_inspirations
  end

  def create_boomerang_inspirations
    pages = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    pages.each do |page|
      boomerang_url = "https://www.franceinter.fr/emissions/boomerang?p=#{page}"
      scrape_boomerang_names(boomerang_url)
    end
  end

  def scrape_boomerang_names(url)
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.xpath('//div[@class="rich-section-list-item-content-show"]/header/div/a').each do |podcast|
      podcast_name = podcast.attributes["title"].value
      podcast_link = podcast.attributes["href"].value
      Inspiration.create(
        inspiration_type: 'podcast',
        source: 'Boomerang',
        duration: 34,
        name: podcast_name,
        url: podcast_link
        )
    end


    # podcast_durations = html_doc.xpath('//span[@class="media-visual-replay-button-duration"]').first.children.first.text
    # podcast_duration = podcast_duration.gsub(/[^0-9]/i, '').to_i

  end


end







