class PlaylistsController < ApplicationApiController
  def index
    render json: Playlist.where(user_id: auth_user.id)
  end

  def show
    playlist = Playlist.find(params[:id])
    render json: PlaylistSerializer.new(playlist, params: { auth_user_id: auth_user.id })
  end

  def create
    Playlist.create! user_id: auth_user.id, **playlist_params
    render json: Playlist.where(user_id: auth_user.id)
  end

  def add_track
    playlist = Playlist.find(params[:id])
    playlist.tracks.create! playlist_id: params[:id], added_by_id: auth_user.id, spotify_id: params[:track_id]

    render json: PlaylistSerializer.new(playlist, params: { auth_user_id: auth_user.id })
  end

  private

  def playlist_params
    params.require(:playlist).permit(:user_id, :name, :description, :song_size)
  end
end
