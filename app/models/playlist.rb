class Playlist < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :user_id, presence: true
  has_many :tracks
  has_many :subscriptions

  def preload_tracks
    @preload_tracks ||= tracks.includes(:votes, :user)
  end

  def real_tracks
    @real_tracks ||= begin
      positive_tracks = preload_tracks.to_a
      positive_tracks.select! { |track| track.vote_score > 0 }
      positive_tracks.sort_by! { |track| [-track.vote_score, track.votes.max_by(&:updated_at)&.updated_at&.to_i || 1] }
      positive_tracks.first(song_size)
    end
  end

  def archived_tracks
    @archived_tracks ||= begin
                           real_track_ids = real_tracks.map(&:id)
                           preload_tracks.to_a.select do |track|
                             next false if real_track_ids.include? track.id

                             date = track.votes.to_a.any? ? track.votes.max_by(&:updated_at).updated_at : track.created_at
                             date < 2.weeks.ago
                           end
    end
  end

  def submission_tracks
    @submission_tracks ||= begin
      real_tracks_ids = real_tracks.map(&:id)
      other_track_ids = real_tracks_ids.concat(archived_tracks.map(&:id))

      tracks.reject { |track| other_track_ids.include? track.id }.sort_by { |track| -track.created_at.to_i }
    end
  end
end
