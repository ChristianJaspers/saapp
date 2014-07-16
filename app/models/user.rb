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
  has_one :api_token, inverse_of: :user
  belongs_to :team, inverse_of: :users

  validates :role, presence: true

  delegate :access_token, to: :api_token, allow_nil: true

  def self.authenticate(email, password)
    user = find_for_authentication(email: email)
    user.try(:valid_for_authentication?) && user.try(:valid_password?, password) ? user : nil
  end

  def locale
    'en'
  end
end
