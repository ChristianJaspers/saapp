class ArgumentRating < ActiveRecord::Base
  belongs_to :rater, class_name: User, inverse_of: :ratings
  belongs_to :argument, inverse_of: :ratings

  validates :rater_id, :argument_id, :rating, presence: true

  enum rating: {
      low: 1,
      medium: 2,
      high: 3
  }
end
