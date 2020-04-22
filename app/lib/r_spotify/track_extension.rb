
module RSpotify
  module TrackExtension
    def self.find(ids, market: nil)
      ids_in_cache, ids_to_cache = ids.partition do |id|
        Rails.cache.exitst?("rspotify:track:#{id}")
      end

      tracks_to_cache = super(ids_to_cache, market: market)
      tracks_to_cache.each do |track|
        Rails.cache.write("rspotify:track:#{track.id}", track, expires_in: 1.day)
      end

      tracks_cached = Rails.cache.fetch_multi(ids_in_cache)
      tracks_to_cache.concat(tracks_cached)
    end
  end
end

RSpotify::Track.prepend RSpotify::TrackExtension
