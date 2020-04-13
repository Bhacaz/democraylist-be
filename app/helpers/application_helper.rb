module ApplicationHelper
  def spotify_user
    @spotify_user ||= RSpotify::User.new(session[:spotify_user])
  end

  def auth_user
    @auth_user ||=
      begin
        token = request.headers['HTTP_AUTHORIZATION'].split(' ').last
        user = User.find_by(access_token: token)
        return unless user # Return nil if no user is found

        if RSpotify::User.class_variable_defined?('@@users_credentials')
          user_credentials = RSpotify::User.class_variable_get('@@users_credentials')
          user_credentials[user.spotify_id]['token'] = token
        end
        user
      end
  end

  def authenticate_request
    if request.headers['HTTP_AUTHORIZATION'].split(' ').first != 'Bearer' || auth_user.nil?
      raise ApplicationApiController::NotAuthorized
    end
  end
end
