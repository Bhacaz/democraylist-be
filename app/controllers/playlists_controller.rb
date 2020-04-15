class PlaylistsController < ApplicationApiController
  def index
    attributes = PlaylistSerializer.attributes_to_serialize.map(&:key) - [:tracks, :tracks_submission]
    query = Playlist.includes(:subscriptions, :user, tracks: [:votes, :user]).where(user_id: auth_user.id)
    render json: PlaylistSerializer.new(query, fields: attributes, params: { auth_user_id: auth_user.id })
  end

  def show
    playlist = Playlist.includes(:subscriptions, tracks: [:votes, :user]).find(params[:id])
    render json: PlaylistSerializer.new(playlist, params: { auth_user_id: auth_user.id })
  end

  def create
    new_playlist = Playlist.create! user_id: auth_user.id, **playlist_params
    spotify_playlist = RSpotify::User.find(auth_user.spotify_id).create_playlist!(playlist_params[:name], public: false, collaborative: true, description: playlist_params[:description])
    new_playlist.update! spotify_id: spotify_playlist.id
    render json: Playlist.where(user_id: auth_user.id)
  end

  def add_track
    playlist = Playlist.includes(:subscriptions, tracks: [:votes, :user]).find(params[:id])
    playlist.tracks.create! playlist_id: params[:id], added_by_id: auth_user.id, spotify_id: params[:track_id]

    render json: PlaylistSerializer.new(playlist, params: { auth_user_id: auth_user.id })
  end

  def explore
    # TODO add algo to fetch the most popular playlist be subcriptionsx
    attributes = PlaylistSerializer.attributes_to_serialize.map(&:key) - [:tracks, :tracks_submission]
    subscription_ids = Playlist.joins(:subscriptions, :user).merge(Subscription.where(user_id: auth_user.id)).ids
    query = Playlist.includes(:subscriptions, :user, tracks: [:votes, :user]).where.not(user_id: auth_user.id).where.not(id: subscription_ids)
    render json: PlaylistSerializer.new(query, fields: attributes, params: { auth_user_id: auth_user.id })
  end

  def subscriptions
    attributes = PlaylistSerializer.attributes_to_serialize.map(&:key) - [:tracks, :tracks_submission]
    query = Playlist.includes(:subscriptions, :user, tracks: [:votes, :user]).joins(:subscriptions).merge(Subscription.where(user_id: auth_user.id))
    render json: PlaylistSerializer.new(query, fields: attributes, params: { auth_user_id: auth_user.id })
  end

  def subscribed
    playlist = Playlist.includes(:subscriptions, tracks: [:votes, :user]).find(params[:id])
    Subscription.create! user_id: auth_user.id, playlist_id: playlist.id
    RSpotify::User.find(auth_user.spotify_id).follow(RSpotify::Playlist.find_by_id(playlist.spotify_id))
    attributes = PlaylistSerializer.attributes_to_serialize.map(&:key) - [:tracks, :tracks_submission]
    render json: PlaylistSerializer.new(playlist, fields: attributes, params: { auth_user_id: auth_user.id })
  end

  def unsubscribed
    playlist = Playlist.includes(:subscriptions, tracks: [:votes, :user]).find(params[:id])
    Subscription.find_by!(user_id: auth_user.id, playlist_id: playlist.id).destroy!
    RSpotify::User.find(auth_user.spotify_id).unfollow(RSpotify::Playlist.find_by_id(playlist.spotify_id))
    attributes = PlaylistSerializer.attributes_to_serialize.map(&:key) - [:tracks, :tracks_submission]
    render json: PlaylistSerializer.new(playlist, fields: attributes, params: { auth_user_id: auth_user.id })
  end

  def stats
    playlist = Playlist.includes(tracks: [:user, { votes: :user }]).find(params[:id])

    # Track sunmittes
    # Track upvoted
    # Tack downvoted
    # Upvote given
    # Downvote given

    implicated_users = playlist.tracks.map(&:user)
    implicated_users.concat(playlist.tracks.flat_map { |track| track.votes.map(&:user) })
    implicated_users.uniq!

    rspotify_user = implicated_users.map { |user| RSpotify::User.find(user.spotify_id) }.index_by(&:id)

    stats = implicated_users.map do |user|
      hash = {}
      hash[:user] = rspotify_user[user.spotify_id].as_json.merge(user.as_json)
      hash[:user].delete('access_token')
      hash[:submission_count] = playlist.tracks.count { |track| track.added_by_id == user.id }
      hash[:submission_upvote_count] = playlist.tracks.select { |track| track.added_by_id == user.id }.sum { |track| track.votes.up.size }
      hash[:submission_downvote_count] = playlist.tracks.select { |track| track.added_by_id == user.id }.sum { |track| track.votes.down.size }
      hash[:upvote_count] = playlist.tracks.flat_map { |track| track.votes.up }.count { |vote| vote.user_id == user.id }
      hash[:downvote_count] = playlist.tracks.flat_map { |track| track.votes.down }.count { |vote| vote.user_id == user.id }
      hash
    end

    render json: stats
  end

  private

  def playlist_params
    params.require(:playlist).permit(:user_id, :name, :description, :song_size)
  end
end
