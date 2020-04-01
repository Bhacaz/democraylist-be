class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :playlist

  validates :user_id, presence: true, uniqueness: { scope: :playlist_id }
end
