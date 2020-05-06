class SendNotifJob < ApplicationJob
  retry_on Exception, attempts: 3

  def perform(notif_data, user_preference)
    NotificationService.send_push notif_data, user_preference
  end
end
