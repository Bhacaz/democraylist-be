module ApplicationHelper
  def spotify_user
    @spotify_user ||= RSpotify::User.new(session[:spotify_user])
  end

  def auth_user
    @auth_user ||=
      begin
        token = request.headers['HTTP_AUTHORIZATION'].split(' ').last
        Rails.cache.read(token)
      end
  end

  def authenticate_request
    if request.headers['HTTP_AUTHORIZATION'].split(' ').first != 'Bearer'
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end
