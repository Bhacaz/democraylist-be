class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :track

  enum vote: [:up, :down]

  validates :user_id, presence: true, uniqueness: { scope: :track_id }
  validates :track_id, presence: true

  after_commit :sync_tracks_with_spotify

  def sync_tracks_with_spotify
    return unless track.playlist.spotify_id

    return if user_id != track.playlist.user_id

    SyncPlaylistJob.perform_later(track.playlist_id)
  end
end
