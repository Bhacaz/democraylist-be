class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :track

  enum vote: [:up, :down]

  validates :user_id, presence: true, uniqueness: { scope: :track_id }
  validates :track_id, presence: true
end
