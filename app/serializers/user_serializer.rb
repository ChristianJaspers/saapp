class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :display_name,
             :email,
             :avatar_url,
             :avatar_thumb_url

  def avatar_url
    object.avatar.url.presence
  end

  def avatar_thumb_url
    object.avatar.url(:thumb).presence
  end
end
