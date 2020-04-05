module ApplicationHelper
  def spotify_user
    @spotify_user ||= RSpotify::User.new(session[:spotify_user])
  end

  def auth_user
    @auth_user ||=
      begin
        token = request.headers['HTTP_AUTHORIZATION'].split(' ').last
        User.find_by!(access_token: token)
      end
  end

  def authenticate_request
    if request.headers['HTTP_AUTHORIZATION'].split(' ').first != 'Bearer' || auth_user.nil?
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end
