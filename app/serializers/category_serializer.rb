class CategorySerializer < ActiveModel::Serializer
  attributes :id,
             :name

  has_many :features
end
