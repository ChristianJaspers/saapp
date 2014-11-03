class Api::V1::RatingsController < Api::RestrictedApplicationController
  def create
    if (rate = Api::RateArgument.call(self)).success?
      render_json(rate.result, 201, serializer: Api::ArgumentRatingWithBadgeSerializer)
    else
      render_fail_json(rate.result)
    end
  end
end
