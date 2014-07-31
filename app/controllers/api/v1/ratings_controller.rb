class Api::V1::RatingsController < Api::RestrictedApplicationController
  def create
    argument = current_user.team.arguments.find_by_id(params[:argument_id])
    rating = argument.ratings.find_by_rater_id(current_user.id)
    rating_value = ArgumentRating.ratings.invert[params[:rating].to_i]

    if !rating && rating_value
      argument_rating = argument.ratings.create(rating: rating_value, rater_id: current_user.id)
      render_json(argument_rating, 201, serializer: Api::ArgumentRatingSerializer)
    else
      render_fail_json(:forbidden)
    end
  end
end
