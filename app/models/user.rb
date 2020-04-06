class User < ApplicationRecord

  validates :spotify_id, presence: true, uniqueness: true
  has_many :playlists
  has_many :votes
  has_many :subscriptions
end
