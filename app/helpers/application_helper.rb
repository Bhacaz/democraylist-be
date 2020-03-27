module ApplicationHelper
  def spotify_user
    @spotify_user ||= RSpotify::User.new(session[:spotify_user])
  end

  def auth_spotify_user
    @auth_spotify_user ||=
      begin
        token = request.headers['HTTP_AUTHORIZATION'].split(' ').last
        Rails.cache.read(token)
      end
  end

  def auth_user
    User.find_by(spotify_id: auth_spotify_user.id)
  end
end
