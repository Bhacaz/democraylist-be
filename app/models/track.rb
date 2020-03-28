class Track < ApplicationRecord
  belongs_to :playlist
  belongs_to :user, foreign_key: :added_by_id
  has_many :votes

  validates :playlist_id, presence: true
  validates :added_by_id, presence: true
end

