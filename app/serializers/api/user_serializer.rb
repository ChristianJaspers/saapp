class Api::UserSerializer < ActiveModel::Serializer
  include Shared::UserAvatarSerializable

  attributes :id,
             :display_name,
             :email,
             :experience,
             :my_activity,
             :my_team_activity,
             :all_teams_activity

  def experience
    object.score
  end

  def my_activity
    return 0 if (goal_score = object.team.goal_score).zero?
    (object.score_in_period * 100.0 / goal_score).to_i
  end

  def my_team_activity
    GoalLevelScore.my_team_activity(object.team).to_i
  end

  def all_teams_activity
    100
  end
end
