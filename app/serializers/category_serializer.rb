class CategorySerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :index_path

  has_many :features

  def index_path
    manager_categories_path
  end
end
