class Api::V1::ArgumentsController < Api::RestrictedApplicationController
  def create
    if (argument = Api::CreateArgument.call(current_user: current_user, argument_params: argument_params)).success?
      render_json(argument.result, 201, serializer: Api::ArgumentRatingSerializer)
    else
      render_fail_json(argument.result)
    end
  end

  def update
    if (argument = Api::UpdateArgument.call(current_user: current_user, argument_params: argument_params, params: params)).success?
      render_json(argument.result, 201, serializer: Api::ArgumentRatingSerializer)
    else
      render_fail_json(argument.result)
    end
  end

  private

  def argument_params
    params.permit(:product_group_id, :feature, :benefit)
  end
end
