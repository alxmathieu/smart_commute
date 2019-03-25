class ScrappingYtVideosForGivenChannelJob < ApplicationJob
  queue_as :default
  Yt.configuration.api_key = ENV['YOUTUBE_API_KEY']

  def perform(id)
    # Do something later
    # arg = channel_id
    channel = Yt::Channel.new id:"#{id}"
    channel.videos.each do |video|
      Inspiration.create(
        url: "https://www.youtube.com/watch?v=#{video.id}",
        name: video.title.gsub(/(.*)( \[EN DIRECT\])/, '\1').to_s,
        # PB avec caractères spéciaux
        duration: video.duration / 60,
        source: "Youtube: #{channel.title}",
        inspiration_type: 'video'
      )
    end
  end

# thinkerview: UCQgWpmt02UtJkyO32HGUASQ
end
