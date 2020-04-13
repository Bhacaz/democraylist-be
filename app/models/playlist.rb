class Playlist < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :user_id, presence: true
  has_many :tracks
  has_many :subscriptions

  def real_tracks
    positive_tracks = tracks.to_a
    positive_tracks.select! { |track| track.vote_score > 0 }
    positive_tracks.sort_by! { |track| [-track.vote_score, track.votes.max_by(&:updated_at)&.updated_at&.to_i || 1] }
    positive_tracks.first(song_size)
  end

  def submission_tracks
    real_tracks_ids = real_tracks.map(&:id)
    tracks.where.not(id: real_tracks_ids).order(created_at: :desc)
  end
end
