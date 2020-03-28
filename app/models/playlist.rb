class Playlist < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :user_id, presence: true
  has_many :tracks

  def real_tracks
    positive_tracks = tracks.to_a.select { |track| track.vote_score > 0 }
    positive_tracks.sort_by! { |track| [-track.vote_score, track.votes.max_by(&:updated_at).updated_at.to_i] }
    positive_tracks.first(song_size)
  end

  def submission_tracks
    real_tracks_ids = real_tracks.map(&:id)
    sub_tracks = tracks.reject { |track| real_tracks_ids.include? track.id }
    sub_tracks.sort_by! { |track| [-track.vote_score, -track.votes.max_by(&:updated_at).updated_at.to_i] }
    sub_tracks
  end
end
