class ScrapeTedJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # retrieve urls for one duration
    # for each, check if video is already in existing inspirations
    # create new one if not
  end

  def method_name

  end


  def build_ted_url(ted_duration)
    ted_url = "https://www.ted.com/talks?sort=jaw-dropping&duration=#{ted_duration}"
  #0-6/6-12/12-18/18%2B
  end

  def scrape_ted_links(url)
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    nodeset = html_doc.xpath('//a')
    hrefs = nodeset.map {|element| element["href"]}.compact
    hrefs.select! {|link| link.start_with?('/talks/')}
    hrefs.uniq!
  end

  def ted_videos_urls(array)
    array.map! {|link|"http://ted.com#{link}"}
  end
end
