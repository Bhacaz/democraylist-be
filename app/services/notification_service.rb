class NotificationService
  def self.send_push(user)
    notification_data = user.push_notif_preference.preference

    message = {
      notification: {
        title: "title",
        body: "body"
      }
    }

    Webpush.payload_send(endpoint: notification_data['endpoint'],
                         message: message.to_json,
                         p256dh: notification_data['keys']['p256dh'],
                         auth: notification_data['keys']['auth'],
                         ttl: 24 * 60 * 60,
                         vapid: {
                           subject: 'mailto:admin@democraylist.com',
                           public_key: ENV['push_public_key'],
                           private_key: ENV['push_private_key']
                         }
    )
  end
end
