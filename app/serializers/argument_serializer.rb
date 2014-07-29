class ArgumentSerializer < ActiveModel::Serializer
  attributes :id, :feature, :benefit, :is_editable, :is_removable

  def is_editable
    scope.is_owner_of?(object) && !object.rated?
  end

  def is_removable
    scope.is_owner_of?(object)
  end
end
