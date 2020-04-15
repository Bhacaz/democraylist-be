class PushNotifPreference < ApplicationRecord
  belongs_to :user

  serialize :preference, Hash
end
