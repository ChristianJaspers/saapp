class Api::TeamSerializer < ActiveModel::Serializer
  self.root = false

  attributes :product_groups

  has_many :sales_representatives, serializer: Api::UserSerializer, key: 'users'
  has_many :arguments, serializer: Api::ArgumentSerializer

  def arguments
    object.arguments.order(:id)
  end

  def product_groups
    object.product_groups.order(:id).map.with_index do |product_group, index|
      Api::ProductGroupSerializer.new(product_group, root: false, position: index + 1)
    end
  end
end
