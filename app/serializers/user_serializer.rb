class UserSerializer < ActiveModel::Serializer
  include Shared::UserAvatarSerializable

  attributes :id,
             :display_name,
             :email,
             :activity_ratio,
             :score

  def activity_ratio
    [object.score(period: Team.comparison_period), object.goal_score]
  end
end
