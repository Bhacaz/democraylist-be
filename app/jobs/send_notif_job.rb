class SendNotifJob < ApplicationJob
  retry_on Exception, attempts: 3

  def perform(notif_data, user_id)
    push_notif_preference = User.find(user_id).push_notif_preference
    NotificationService.send_push notif_data, push_notif_preference.preference
  end
end
