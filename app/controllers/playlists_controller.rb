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

  def remove_track
    Track.find_by!(playlist_id: params[:id], spotify_id: params[:track_id]).destroy!

    render json: :ok
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

  private

  def playlist_params
    params.require(:playlist).permit(:user_id, :name, :description, :song_size)
  end
end
