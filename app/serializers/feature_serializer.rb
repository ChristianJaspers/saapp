class FeatureSerializer < ActiveModel::Serializer
  attributes :id, :description

  has_one :benefit
end
