class Wizard
  include ActiveModel::Model

  attr_accessor :email, :invitations, :categories

  validates :email, presence: true, email: true

  def attributes=(attrs)
    self.email = attrs.fetch(:email, '')
    self.invitations = attrs.fetch(:invitations, [])
    self.categories = attrs.fetch(:categories, [])
  end
end
