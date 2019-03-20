require 'watir'

class ScrapeMediumFeaturedStoriesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    scrape_medium_story_create_inspirations
  end

  # Need to add something to get clear of articles older than 30 days or something
  # set deleted_at, in order for them not to show up, but for people to still see them on their dashboard, if they "liked" them



  def scrape_medium_story_create_inspirations
    url = "https://medium.com/topic/editors-picks"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    # browser = Watir::Browser.new
    # browser.goto 'https://medium.com/topic/editors-picks'

    # html_doc = Nokogiri::HTML.parse(browser.html)


    html_doc.xpath("//div[contains(concat(' ',normalize-space(@class)), 'l el q s em bz en eo ep v')]").each do |card|
      #ai y cl bj cm bk dq ez fa ak an ds cr gk gl
      article_name = card.search('.ai.y.ce.at.cf.au.dj.er.es.ak.an.dl.ck.cl.cm').first.children.first.children.text unless card.search('.ai.y.ce.at.cf.au.dj.er.es.ak.an.dl.ck.cl.cm').empty?
      article_link = card.xpath(".//div[contains(concat(' ',normalize-space(@class)), 'eq d ep v cc')]/div/a/@href").first.value
      duration_text = card.xpath(".//div[contains(concat(' ',normalize-space(@class)), 'dw s dx')]").first.text
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

  # it's not getting all articles ??

end
