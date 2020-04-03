
class SyncPlaylistJob < ApplicationJob
  queue_as :default

  def perform(playlist_id)
    # Do something later
  end
end
