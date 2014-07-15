class Wizard
  include ActiveModel::Model

  attr_reader :attributes

  delegate :email, :categories, :invitations, to: :attributes

  validates :email, presence: true, email: true

  def attributes=(attrs)
    @attributes = Dish(attrs)
  end
end
