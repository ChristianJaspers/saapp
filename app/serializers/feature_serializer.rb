class FeatureSerializer < ActiveModel::Serializer
  attributes :id, :description, :benefit_description, :is_editable, :is_removable

  delegate :benefit, to: :object
  delegate :description, to: :benefit, prefix: true

  def is_editable
    scope.is_owner_of?(object) && !object.rated?
  end

  def is_removable
    scope.is_owner_of?(object)
  end
end
