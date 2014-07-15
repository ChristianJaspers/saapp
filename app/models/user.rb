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

  has_many :categories, inverse_of: :owner, foreign_key: :owner_id
  has_many :features, inverse_of: :owner
  belongs_to :team, inverse_of: :users

  validates :role, presence: true
end
