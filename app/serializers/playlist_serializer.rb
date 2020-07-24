class PlaylistSerializer
  include BrightSerializer::Serializer

  attributes *Playlist.attribute_names.map(&:to_sym)

  attribute :image_url do |object|
    RSpotify::Playlist.find_by_id(object.spotify_id).images.first&.fetch('url') if object.spotify_id
  end

  attribute :uri do |object|
    "spotify:playlist:#{object.spotify_id}"
  end

  attribute :created_by do |object|
    {
      id: object.user_id,
      display_name: object.user.name,
      spotify_id: object.user.spotify_id
    }
  end

  attribute :subscribed do |object, params|
    object.subscriptions.exists?(user_id: params[:auth_user_id])
  end

  attribute :up_vote_count do |object|
    Vote.joins(track: :playlist).merge(Playlist.where(id: object.id)).where(vote: :up).size
  end

  attribute :down_vote_count do |object|
    Vote.joins(track: :playlist).merge(Playlist.where(id: object.id)).where(vote: :down).size
  end

  attribute :subscribers do |object|
    object.subscriptions.count
  end

  attribute :tracks_count do |object|
    object.real_tracks.size
  end

  attribute :tracks do |object, params|
    tracks = object.real_tracks
    next [] if tracks.empty?

    tracks_data = RSpotify::Track.find(tracks.map(&:spotify_id)).index_by(&:id)
    tracks.map do |track|
      tracks_data[track.spotify_id].as_json.merge!(TrackSerializer.new(track, params: params).to_hash)
    end
  end

  attribute :tracks_submission do |object, params|
    tracks = object.submission_tracks
    next [] if tracks.empty?

    tracks_data = RSpotify::Track.find(tracks.map(&:spotify_id)).index_by(&:id)
    tracks.map do |track|
      tracks_data[track.spotify_id].as_json.merge!(TrackSerializer.new(track, params: params).to_hash)
    end
  end

  attribute :tracks_submission_count do |object|
    object.submission_tracks.size
  end

  attribute :tracks_archived do |object, params|
    tracks = object.archived_tracks
    next [] if tracks.empty?

    tracks_data = RSpotify::Track.find(tracks.map(&:spotify_id)).index_by(&:id)
    tracks.map do |track|
      tracks_data[track.spotify_id].as_json.merge!(TrackSerializer.new(track, params: params).to_hash)
    end
  end

  attribute :tracks_archived_count do |object|
    object.archived_tracks.size
  end
end
