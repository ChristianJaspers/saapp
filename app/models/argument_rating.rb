class ArgumentRating < ActiveRecord::Base
  belongs_to :rater, class_name: User, inverse_of: :ratings
  belongs_to :argument, inverse_of: :ratings
end
