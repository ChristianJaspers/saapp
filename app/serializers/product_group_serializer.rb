class ProductGroupSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :index_path

  has_many :arguments

  def index_path
    manager_product_groups_path
  end
end
