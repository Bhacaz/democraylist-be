class NotificationService
  def self.broadcast_added_track(track)
    user_ids = track.playlist.subscriptions.map(&:user_id) << track.playlist.user_id
    user_ids.delete(track.added_by_id)

    message = build_message(track)
    User.joins(:push_notif_preference).where(id: user_ids).distinct.each do |user|
      SendNotifJob.perform_later(message, user.push_notif_preference.preference)
    end
  end

  def self.send_push(message, notification_data)
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

  def self.build_message(track)
    badge = ENV['democraylist_fe_host'] + '/assets/icons/icon-512x512-white.png'
    icon = RSpotify::Track.find(track.spotify_id).album.images.last['url']
    user_name = track.user.name
    rspotify_track = RSpotify::Track.find(track.spotify_id)
    playlist_name = track.playlist.name
    title = "Democraylist - #{playlist_name}"
    body = "#{rspotify_track.name} - #{rspotify_track.artists.map(&:name).join(', ')}\nAdded by #{user_name}"

    # Link to song in playlist
    url = ENV['democraylist_fe_host'] + "/playlists/#{track.playlist_id}?track_id=#{track.id}"
    {
      notification: {
        icon: icon,
        badge: badge,
        title: title,
        body: body,
        vibrate: [200, 100, 200],
        data: { url: url }
      }
    }
  end
end
