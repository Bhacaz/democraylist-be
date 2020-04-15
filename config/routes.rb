Rails.application.routes.draw do
  root 'auth#login'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :users do
    get :playlists
    post '/push_notif_preference', to: 'users#create_push_notif_preference', on: :collection
  end

  resource :playlists do
    get '/', to: 'playlists#index'
    get '/explore', to: 'playlists#explore'
    get '/subscriptions', to: 'playlists#subscriptions'
    post '/create', to: 'playlists#create'
    get '/:id', to: 'playlists#show'
    get '/:id/stats', to: 'playlists#stats'
    post '/:id/add_track', to: 'playlists#add_track'
    post '/:id/subscribed', to: 'playlists#subscribed'
    post '/:id/unsubscribed', to: 'playlists#unsubscribed'
  end
  
  resource :tracks, default: :json do
    get :search
    get ':id', to: 'tracks#show'
    patch ':id/up_vote', to: 'tracks#up_vote'
    patch ':id/down_vote', to: 'tracks#down_vote'
    delete ':id', to: 'tracks#delete'
  end

  get '/auth/spotify/callback', to: 'auth#spotify'
  get '/auth/spotify_login_url', to: 'auth#spotify_login_url'
  get '/auth/user', to: 'auth#user'
  get '/auth/refresh_access_token', to: 'auth#refresh_access_token'
  post '/auth/spotify_get_token', to: 'auth#spotify_get_token'

  get '/login', to: 'auth#login'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
