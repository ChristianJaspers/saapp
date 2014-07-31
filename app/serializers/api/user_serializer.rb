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
    return 0 if object.team.goal_score.zero?
    object.score_in_period * 100.0 / object.team.goal_score
  end

  def my_team_activity
    return 0 if object.company.goal_score.zero?
    object.team.score_in_period * 100 / object.company.goal_score
  end

  def all_teams_activity
    return 0 if Company.overall_goal_score.zero?
    object.company.score_in_period * 100 / Company.overall_goal_score
  end
end
