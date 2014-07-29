class Wizard
  include ActiveModel::Model

  attr_reader :attributes

  delegate :email, :product_groups, :invitations, to: :attributes, allow_nil: true

  validates :email, presence: true, email: true
  validate :email_uniqueness

  def attributes=(attrs)
    @attributes = Dish(attrs.deep_transform_keys(&:underscore))
  end

  private

  def email_uniqueness
    errors.add(:email, :taken) if User.where(email: email).exists?
  end
end
