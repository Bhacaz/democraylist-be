
class SendNotifJob
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(track_id)
    NotificationService.broadcast_added_track(Track.find(track_id))
  end
end
