class Api::RateArgument < BusinessProcess::Base
  include BusinessProcess::Errorable
  extend BusinessProcess::Transactional
  transaction_for ArgumentRating

  needs :params
  needs :current_user

  def call
    find_argument and
      validate_rating_value and
      rate_argument and
      rating
  end

  private

  attr_reader :argument, :rating, :rating_value

  def find_argument
    check_for_error :argument_not_found do
      @argument = current_user.team.arguments.find_by_id(params[:argument_id])
    end
  end

  def rate_argument
    check_for_error :argument_already_rated do
      @rating = argument.ratings.create(rating: rating_value, rater: current_user)
      rating.persisted?
    end
  end

  def validate_rating_value
    check_for_error :invalid_rating do
      @rating_value = ArgumentRating.ratings.invert[params[:rating].to_i]
    end
  end
end
