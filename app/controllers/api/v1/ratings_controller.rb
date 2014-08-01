class Api::V1::RatingsController < Api::RestrictedApplicationController
  def create
    if (rate = Api::RateArgument.call(current_user: current_user, params: params)).success?
      render_json(rate.result, 201, serializer: Api::ArgumentRatingSerializer)
    else
      render_fail_json(:forbidden)
    end
  end
end
