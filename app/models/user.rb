class User < ApplicationRecord

  validates :spotify_id, presence: true, uniqueness: true
  has_many :playlists
  has_many :votes
  has_many :subscriptions
  has_one :push_notif_preference

  def rspotify_user
    RSpotify::User.new('id' => spotify_id, 'credentials' => { 'token' => access_token })
  end
end
