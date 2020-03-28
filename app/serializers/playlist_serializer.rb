class PlaylistSerializer
  include BrightSerializer::Serializer

  attributes *Playlist.attribute_names.map(&:to_sym)

  attribute :tracks do |object, params|
    tracks = object.real_tracks
    tracks_data = RSpotify::Track.find(tracks.map(&:spotify_id)).index_by(&:id)
    tracks.map do |track|
      tracks_data[track.spotify_id].as_json.merge(TrackSerializer.new(track, params: params).to_hash)
    end
  end

  attribute :tracks_submission do |object, params|
    tracks = object.submission_tracks
    tracks_data = RSpotify::Track.find(tracks.map(&:spotify_id)).index_by(&:id)
    tracks.map do |track|
      tracks_data[track.spotify_id].as_json.merge(TrackSerializer.new(track, params: params).to_hash)
    end
  end
end
