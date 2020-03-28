class TrackSerializer
  include BrightSerializer::Serializer

  attributes *Track.attribute_names.map(&:to_sym)

  attribute :vote_count do |object|
    up = object.votes.to_a.count { |v| v.vote == 'up' }
    down = object.votes.to_a.count { |v| v.vote == 'down' }
    up - down
  end

  attribute :my_vote do |object, params|
    object.votes.detect { |vote| vote.user_id == params[:auth_user_id] }&.vote
  end
end
