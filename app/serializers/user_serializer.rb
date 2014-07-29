class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :display_name,
             :email,
             :avatar_url,
             :avatar_thumb_url,
             :activity_ratio,
             :score

  def avatar_url
    object.avatar.url.presence
  end

  def avatar_thumb_url
    object.avatar.url(:thumb).presence
  end

  def activity_ratio
    [object.score(period: Team.comparison_period), object.goal_score]
  end
end
