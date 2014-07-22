class Wizard
  include ActiveModel::Model

  attr_reader :attributes

  delegate :email, :categories, :invitations, to: :attributes, allow_nil: true

  validates :email, presence: true, email: true

  def attributes=(attrs)
    @attributes = Dish(attrs.deep_transform_keys(&:underscore))
  end
end
