class CreatePushNotifPreferenceTable < ActiveRecord::Migration[6.0]
  def change
    create_table :push_notif_preferences do |t|
      t.references :user, index: true
      t.string :preference
    end
  end
end
