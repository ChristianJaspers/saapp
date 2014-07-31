module Shared::UserAvatarSerializable
  extend ActiveSupport::Concern

  included do
    attributes :avatar_url,
               :avatar_thumb_url
  end

  def avatar_url
    object.avatar.url.presence
  end

  def avatar_thumb_url
    object.avatar.url(:thumb).presence
  end
end
