class Wizard
  include ActiveModel::Model

  attr_accessor :email

  validates :email, presence: true, email: true

  def attributes=(attrs)
    self.email = attrs[:email]
  end
end


