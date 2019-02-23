class ScrapeTedJob < ApplicationJob
  queue_as :default

  def perform(*args)
    create_inspiration
  end

  def create_inspiration
    inspiration = Inspiration.create(source: 'ted', duration: 10, type: 'video')
  end
end
