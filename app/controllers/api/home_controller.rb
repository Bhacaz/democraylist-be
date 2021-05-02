module Api
  class HomeController < ApplicationApiController
    def index
      attributes = PlaylistSerializer.attributes_to_serialize.map(&:key) -  Api::PlaylistsController::INDEX_EXCLUDED_ATTRIBUTES
      playlist_subscrib_ids = Playlist.joins(:subscriptions).merge(Subscription.where(user_id: auth_user.id)).ids
      my_playlist_ids = Playlist.where(user_id: auth_user.id).ids

      query = Playlist.where(id: playlist_subscrib_ids.concat(my_playlist_ids))
              .includes(:subscriptions, :user, tracks: [:votes, :user])
              .sort_by do |playlist|
        -(playlist&.tracks.max_by(&:created_at).created_at.to_i || playlist.created_at.to_i)
      end
      render json: PlaylistSerializer.new(query, fields: attributes, params: { auth_user_id: auth_user.id })
    end
  end
end
