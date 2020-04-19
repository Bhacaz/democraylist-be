class Playlist < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :user_id, presence: true
  has_many :tracks
  has_many :subscriptions

  def real_tracks
    @real_tracks ||= begin
      positive_tracks = tracks.to_a
      positive_tracks.select! { |track| track.vote_score > 0 }
      positive_tracks.sort_by! { |track| [-track.vote_score, track.votes.max_by(&:updated_at)&.updated_at&.to_i || 1] }
      positive_tracks.first(song_size)
    end
  end

  def archived_tracks
    @archived_tracks ||= begin
                           tracks.where.not(id: real_tracks.map(&:id)).includes(:votes).to_a.select do |track|
                             date = track.votes.to_a.any? ? track.votes.order(:updated_at).last.updated_at : track.created_at
                             date < 2.weeks.ago
                           end
    end
  end

  def submission_tracks
    @submission_tracks ||= begin
      real_tracks_ids = real_tracks.map(&:id)
      archived_tracks_ids = archived_tracks.map(&:id)
      tracks.where.not(id: real_tracks_ids.concat(archived_tracks_ids)).order(created_at: :desc)
    end
  end
end
