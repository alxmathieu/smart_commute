class ScrappingYtVideosForGivenPlaylistJob < ApplicationJob
  queue_as :default
Yt.configuration.api_key = ENV['YOUTUBE_API_KEY']

  def perform(id)
    playlist = Yt::Playlist.new id:"#{id}"
    playlist.playlist_items.each do |item|
      video = item.video
      next if video.description.to_s.include? "Disponible jusqu'au"
      begin
        Inspiration.create(
          url: "https://www.youtube.com/watch?v=#{video.id}",
          name: video.title.gsub(/(.*)( \| ARTE)/, '\1').to_s,
          # PB avec caractères spéciaux
          duration: video.duration / 60,
          source: "Youtube: #{playlist.channel_title}",
          inspiration_type: 'video'
        )
      rescue Yt::Errors::NoItems
       next
      end
    end
  end


end

# test : PLCwXWOyIR22t9pAk-Epd6jAJjycxATPOE
