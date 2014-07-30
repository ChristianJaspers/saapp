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
    0
  end

  def my_activity
    0
  end

  def my_team_activity
    0
  end

  def all_teams_activity
    0
  end
end
