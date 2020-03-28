class TrackSerializer
  include BrightSerializer::Serializer

  attributes *Track.attribute_names.map(&:to_sym)

  attribute :vote_count do |object|
    object.vote_score
  end

  attribute :my_vote do |object, params|
    object.votes.detect { |vote| vote.user_id == params[:auth_user_id] }&.vote
  end
end
