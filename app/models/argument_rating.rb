class ArgumentRating < ActiveRecord::Base
  include Gamification::Gamified

  belongs_to :rater, class_name: User, inverse_of: :ratings
  belongs_to :argument, inverse_of: :ratings

  validates :rater_id, :argument_id, :rating, presence: true
  validates :argument_id, uniqueness: {scope: :rater_id}

  delegate :owner, to: :argument, prefix: true

  enum rating: {
      low: 1,
      medium: 2,
      high: 3
  }

  gamify :creation, as: :rating
end
