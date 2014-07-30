class Api::UserSerializer < ActiveModel::Serializer
  attributes :id,
             :display_name,
             :email,
             :avatar_url,
             :avatar_thumb_url,
             :my_activity,
             :my_team_activity,
             :all_teams_activity

  def avatar_url
    object.avatar.url.presence
  end

  def avatar_thumb_url
    object.avatar.url(:thumb).presence
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
