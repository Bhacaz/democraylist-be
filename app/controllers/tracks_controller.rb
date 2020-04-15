class TracksController < ApplicationApiController

  def search
    limit = params[:limit] || 5
    render json: RSpotify::Track.search(params[:q], limit: limit)
  end

  def show
    render json: RSpotify::Track.find(params[:id])
  end

  def up_vote
    vote = Vote.find_or_initialize_by(track_id: params[:id], user_id: auth_user.id)
    vote.vote = :up
    vote.save!
    render json: vote
  end

  def down_vote
    vote = Vote.find_or_initialize_by(track_id: params[:id], user_id: auth_user.id)
    vote.vote = :down
    vote.save!
    render json: vote
  end

  def delete
    Track.find(params[:id]).destroy!
  end
end
