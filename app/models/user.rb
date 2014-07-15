class User < ActiveRecord::Base
  enum role: {
    user: 0,
    manager: 1,
    admin: 2
  }

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  has_many :categories, inverse_of: :owner
  has_many :features, inverse_of: :owner

  validates :role, presence: true
end
