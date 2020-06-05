class User < ApplicationRecord

  validates :spotify_id, presence: true, uniqueness: true
  has_many :playlists
  has_many :votes
  has_many :subscriptions
  has_many :tracks, foreign_key: :added_by_id
  has_one :push_notif_preference

  def rspotify_user
    RSpotify::User.new('id' => spotify_id, 'credentials' => { 'token' => access_token, 'refresh_token' => refresh_token })
  end
end
