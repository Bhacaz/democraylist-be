require 'httparty'

class AuthController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:spotify_get_token]
  skip_before_action :authenticate_request, except: [:user, :refresh_access_token]

  def spotify
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    session[:spotify_user] = @spotify_user.to_hash

    user = User.find_or_initialize_by(email: @spotify_user.email)
    user.spotify_id = @spotify_user.id
    user.name = @spotify_user.display_name
    user.save!
    redirect_to user_url(user)
  end

  def login; end

  def spotify_login_url
    query_params = {
      response_type: 'code',
      client_id: ENV['spotify_client_id'],
      scope: 'user-read-email playlist-read-private playlist-read-collaborative playlist-modify-private playlist-modify-public user-library-read user-library-modify',
      redirect_uri: 'http://localhost:4200/auth/spotify/callback'
    }

    render json: { url: 'https://accounts.spotify.com/authorize?' + query_params.to_query }
  end

  def spotify_get_token
    # Get token from code
    body = {
      grant_type: 'authorization_code',
      code: params[:code],
      redirect_uri: 'http://localhost:4200/auth/spotify/callback',
      client_id: ENV['spotify_client_id'],
      client_secret: ENV['spotify_client_secret']
    }

    response = ::HTTParty.post(
      'https://accounts.spotify.com/api/token',
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      :body => body.to_query
    )

    access_token = response['access_token']

    credentials = Hashie::Mash.new(
      token: access_token,
      refresh_token: response['refresh_token'],
      expires_at: response['expires_in'] + Time.now.to_i,
      expires: true
    )

    response = HTTParty.get(
      'https://api.spotify.com/v1/me',
      headers: { 'Authorization' => "Bearer #{access_token}" }
    )

    user = User.find_or_initialize_by(spotify_id: response['id'])
    user.email = response['email']
    user.name = response['display_name']
    user.save! if user.changed?

    r_user = RSpotify::User.new(**Hashie::Mash.new(response), 'credentials' => credentials)
    user = User.find_by!(spotify_id: r_user.id)
    Rails.cache.write(access_token, user, expires_in: 60.minutes)

    render json: { access_token: access_token, user: r_user.as_json.merge(user.as_json) }
  end

  def user
    render json: { user: auth_user }
  end

  def refresh_access_token
    access_token = RSpotify::User.send(:refresh_token, auth_user.spotify_id)
    Rails.cache.write(access_token, auth_user, expires_in: 60.minutes)

    render json: { access_token: access_token }
  end
end
