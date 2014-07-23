class FeatureSerializer < ActiveModel::Serializer
  attributes :id, :description, :benefit_description

  delegate :benefit, to: :object
  delegate :description, to: :benefit, prefix: true
end
