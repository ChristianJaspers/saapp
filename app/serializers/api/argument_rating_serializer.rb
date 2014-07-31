class Api::ArgumentRatingSerializer < ActiveModel::Serializer
  self.root = false

  has_one :rater, serializer: Api::UserSerializer, key: 'user'
  has_one :argument, serializer: Api::ArgumentSerializer
end
