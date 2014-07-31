class User < ActiveRecord::Base
  include Gamification::Beneficiary
  include Model::DelayedDestroy

  enum role: {
      user: 0,
      manager: 1,
      admin: 2
  }

  class << self
    alias_method :users, :user
    alias_method :managers, :manager
    alias_method :admins, :admin
  end

  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable

  include User::DeviseConfirmableActivation

  has_many :product_groups, inverse_of: :owner, foreign_key: :owner_id
  has_many :arguments, inverse_of: :owner
  has_many :ratings, class_name: ArgumentRating, inverse_of: :rater
  has_one :api_token, inverse_of: :user
  belongs_to :team, inverse_of: :users

  validates :role, presence: true

  delegate :access_token, to: :api_token, allow_nil: true
  delegate :goal_score, :comparison_period, to: :team

  has_attached_file :avatar, styles: {thumb: '100x100>'}, default_url: ''
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def self.authenticate(email, password)
    user = find_for_authentication(email: email)
    user.try(:valid_for_authentication?) && user.try(:valid_password?, password) ? user : nil
  end

  def is_owner_of?(object)
    object.owner_id == id
  end

  def locale
    'en'
  end

  alias_method :manager, :manager?

  def manager=(value)
    self.role = value ? 'manager' : 'user'
  end

  def activate_with_new_password!(new_password)
    self.password = self.password_confirmation = new_password
    confirm!
  end
end
