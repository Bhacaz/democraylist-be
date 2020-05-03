
class SendNotifJob < ApplicationJob
  queue_as :default
  retry_on Exception, attempts: 3

  def perform(track_id)
    NotificationService.broadcast_added_track(Track.find(track_id))
  end
end

