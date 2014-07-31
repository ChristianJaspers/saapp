class UserSerializer < ActiveModel::Serializer
  include Shared::UserAvatarSerializable

  attributes :id,
             :display_name,
             :email
end
