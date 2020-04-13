
class SyncPlaylistJob < ApplicationJob
  queue_as :default

  def perform(playlist_id)
    (1..10).each { |i| puts 'Hello world ' + i.to_s }
  end
end
