class Api::RateArgument < BusinessProcess::Base
  extend BusinessProcess::Transactional
  transaction_for ArgumentRating

  needs :params
  needs :current_user

  def call
    find_argument and rate_argument
  end

  private

  def find_argument
    @argument ||= current_user.team.arguments.find_by(id: params[:argument_id])
  end

  alias_method :argument, :find_argument

  def rate_argument
    if (rating = argument.ratings.create(rating: rating_value, rater_id: current_user.id)).persisted?
      rating
    else
      false
    end
  end

  def rating_value
    ArgumentRating.ratings.invert[params[:rating].to_i]
  end
end
