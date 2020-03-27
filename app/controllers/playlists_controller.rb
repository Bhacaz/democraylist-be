class PlaylistsController < ApplicationApiController
  def index
    render json: Playlist.where(user_id: auth_user.id)
  end

  def show
    playlist = Playlist.find(params[:id])
    playlist_json = playlist.as_json
    tracks_data = RSpotify::Track.find(playlist.tracks.map(&:spotify_id)).index_by(&:id)
    playlist_json['tracks'] = playlist.tracks.map do |track|
      tracks_data[track.spotify_id].as_json.merge(track.as_json)
    end
    render json: playlist_json
  end

  def create
    Playlist.create! user_id: auth_user.id, **playlist_params
    render json: Playlist.where(user_id: auth_user.id)
  end

  def add_track
    playlist = Playlist.find(params[:id])
    playlist.tracks.create! playlist_id: params[:id], added_by_id: auth_user.id, spotify_id: params[:track_id]

    playlist_json = playlist.as_json
    tracks_data = RSpotify::Track.find(playlist.tracks.map(&:spotify_id)).index_by(&:id)
    playlist_json['tracks'] = playlist.tracks.map do |track|
      tracks_data[track.spotify_id].as_json.merge(track.as_json)
    end

    render json: playlist_json
  end

  private

  def playlist_params
    params.require(:playlist).permit(:user_id, :name, :description, :size)
  end
end
