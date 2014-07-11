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

  validates :role, presence: true

  def current_locale
    'en'
  end
end
