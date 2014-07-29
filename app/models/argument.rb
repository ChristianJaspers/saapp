class Argument < ActiveRecord::Base
  include Gamification::Gamified

  belongs_to :owner, class_name: User, inverse_of: :arguments
  belongs_to :product_group, inverse_of: :arguments, counter_cache: true
  has_many :ratings, class_name: ArgumentRating, inverse_of: :argument

  validates :feature, :benefit, presence: true

  gamify :creation, as: :argument_creation

  def rated?
    false #FIXME Implementation pending
  end
end
