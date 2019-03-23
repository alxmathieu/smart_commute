class ScrapeMediumTopClappedJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    scrape_medium_top_clapped
  end


  def scrape_medium_top_clapped
    url = 'https://topmediumstories.com/'
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search('.story').each do |element|
      article_name = element.search('.title').text.strip
      article_link = element.search('.title').attribute('href').value
      begin
        article_file = open(article_link).read
      rescue
        next
      end
      article_html_doc = Nokogiri::HTML(article_file)
      duration_text = article_html_doc.search('.readingTime').first.values.last
      article_duration = duration_text.gsub(/(\D+\s)(\d+.)(\d+)(.*)/, '\3').to_i
      Inspiration.create(
        inspiration_type: 'article',
        source: 'Medium',
        duration: article_duration + 1, # because Medium round it below ?
        name: article_name,
        url: article_link
      )
    end
  end
end
