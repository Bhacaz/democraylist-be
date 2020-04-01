class PlaylistSerializer
  include BrightSerializer::Serializer

  attributes *Playlist.attribute_names.map(&:to_sym)

  attribute :subscribed do |object, params|
    Subscription.exists?(playlist_id: object.id, user_id: params[:auth_user_id])
  end

  attribute :tracks do |object, params|
    tracks = object.real_tracks
    next [] if tracks.empty?

    tracks_data = RSpotify::Track.find(tracks.map(&:spotify_id)).index_by(&:id)
    tracks.map do |track|
      tracks_data[track.spotify_id].as_json.merge(TrackSerializer.new(track, params: params).to_hash)
    end
  end

  attribute :tracks_submission do |object, params|
    tracks = object.submission_tracks
    next [] if tracks.empty?

    tracks_data = RSpotify::Track.find(tracks.map(&:spotify_id)).index_by(&:id)
    tracks.map do |track|
      tracks_data[track.spotify_id].as_json.merge(TrackSerializer.new(track, params: params).to_hash)
    end
  end
end
