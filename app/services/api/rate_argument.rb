class Api::RateArgument < BusinessProcess::Base
  needs :params
  needs :current_user

  def call
    find_argument and
      validate_rating_value and
      make_sure_there_is_no_rating and
      rate
  end

  private

  attr_reader :argument, :rating_value

  def find_argument
    @argument ||= current_user.team.arguments.find_by_id(params[:argument_id])
  end

  def make_sure_there_is_no_rating
    !argument.ratings.find_by_rater_id(current_user.id)
  end

  def rate
    result = argument.ratings.create(rating: rating_value, rater_id: current_user.id)
    result if result.persisted?
  end

  def validate_rating_value
    @rating_value ||= ArgumentRating.ratings.invert[params[:rating].to_i]
  end
end
