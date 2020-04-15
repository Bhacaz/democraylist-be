class Track < ApplicationRecord
  belongs_to :playlist
  belongs_to :user, foreign_key: :added_by_id
  has_many :votes

  validates :playlist_id, presence: true
  validates :added_by_id, presence: true
  validates :spotify_id, uniqueness: { scope: :playlist_id }

  after_commit :send_notification, on: :create

  def vote_score
    up = votes.to_a.count { |vote| vote.vote == 'up' }
    down = votes.to_a.count { |vote| vote.vote == 'down' }
    up - down
  end

  def uri
    "spotify:track:#{spotify_id}"
  end

  def send_notification
    SendNotifJob.perform_later(id)
  end
end
