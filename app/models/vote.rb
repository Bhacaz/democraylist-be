class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :track

  enum vote: [:up, :down]

  validates :user_id, presence: true
  validates :track_id, presence: true
end
