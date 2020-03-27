class TracksController < ApplicationApiController

  def search
    limit = params[:limit] || 5
    render json: RSpotify::Track.search(params[:q], limit: limit)
  end

  def show
    render json: RSpotify::Track.find(params[:id])
  end
end
