class PlaylistsController < ApplicationApiController
  def index
    attributes = PlaylistSerializer.attributes_to_serialize.map(&:key) - [:tracks, :tracks_submission]
    render json: PlaylistSerializer.new(Playlist.where(user_id: auth_user.id), fields: attributes, params: { auth_user_id: auth_user.id })
  end

  def show
    playlist = Playlist.find(params[:id])
    render json: PlaylistSerializer.new(playlist, params: { auth_user_id: auth_user.id })
  end

  def create
    new_playlist = Playlist.create! user_id: auth_user.id, **playlist_params
    spotify_playlist = RSpotify::User.find(auth_user.spotify_id).create_playlist!(playlist_params[:name], public: false, collaborative: true, description: playlist_params[:description])
    new_playlist.update! spotify_id: spotify_playlist.id
    render json: Playlist.where(user_id: auth_user.id)
  end

  def add_track
    playlist = Playlist.find(params[:id])
    playlist.tracks.create! playlist_id: params[:id], added_by_id: auth_user.id, spotify_id: params[:track_id]

    render json: PlaylistSerializer.new(playlist, params: { auth_user_id: auth_user.id })
  end

  def explore
    # TODO add algo to fetch the most popular playlist be subcriptions
    attributes = PlaylistSerializer.attributes_to_serialize.map(&:key) - [:tracks, :tracks_submission]
    render json: PlaylistSerializer.new(Playlist.first(10), fields: attributes, params: { auth_user_id: auth_user.id })
  end

  def subscriptions
    attributes = PlaylistSerializer.attributes_to_serialize.map(&:key) - [:tracks, :tracks_submission]
    render json: PlaylistSerializer.new(Playlist.joins(:subscriptions).merge(Subscription.where(user_id: auth_user.id)), fields: attributes, params: { auth_user_id: auth_user.id })
  end

  def subscribed
    Subscription.create! user_id: auth_user.id, playlist_id: params[:id]
    attributes = PlaylistSerializer.attributes_to_serialize.map(&:key) - [:tracks, :tracks_submission]
    render json: PlaylistSerializer.new(Playlist.find(params[:id]), fields: attributes, params: { auth_user_id: auth_user.id })
  end

  def unsubscribed
    Subscription.find_by!(user_id: auth_user.id, playlist_id: params[:id]).destroy!
    attributes = PlaylistSerializer.attributes_to_serialize.map(&:key) - [:tracks, :tracks_submission]
    render json: PlaylistSerializer.new(Playlist.find(params[:id]), fields: attributes, params: { auth_user_id: auth_user.id })
  end

  private

  def playlist_params
    params.require(:playlist).permit(:user_id, :name, :description, :song_size)
  end
end
