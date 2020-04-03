module RSpotify
  module UserExtension
    def create_playlist!(name, public: false, **options)
      url = "users/#{@id}/playlists"
      request_data = { name: name, public: public, **options }.to_json

      response = User.oauth_post(@id, url, request_data)
      return response if RSpotify.raw_response
      Playlist.new response
    end
  end
end

RSpotify::User.prepend RSpotify::UserExtension
