class PlaylistSerializer
  include BrightSerializer::Serializer

  attributes *Playlist.attribute_names.map(&:to_sym)

  attribute :tracks do |object, params|
    tracks_data = RSpotify::Track.find(object.tracks.map(&:spotify_id)).index_by(&:id)
    object.tracks.map do |track|
      tracks_data[track.spotify_id].as_json.merge(TrackSerializer.new(track, params: params).to_hash)
    end
  end
end
