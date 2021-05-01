module Api
  class PlaylistsController < ApplicationApiController

    def index
      Playlist.where(user_id: auth_user.id).or(Playlist.joins(:subscriptions).merge(Subscription.where(user_id: auth_user.id))).joins(:tracks).order('tracks.created_at DESC')
    end
  end
end
