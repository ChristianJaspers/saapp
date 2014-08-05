class Api::V1::ArgumentsController < Api::RestrictedApplicationController
  def create
    product_group = current_user.team.product_groups.find_by_id(argument_params[:product_group_id])

    if product_group
      argument = product_group.arguments.build(
        owner_id: current_user.id,
        feature: argument_params[:feature],
        benefit: argument_params[:benefit]
      )

      if argument.save
        render_json(ArgumentRating.new(argument: argument, rater: current_user), 201, serializer: Api::ArgumentRatingSerializer)
      else
        render_fail_json(:missing_feature_or_benefit)
      end
    else # missing product group
      render_fail_json(:missing_product_group)
    end
  end

  def update
    head :ok
  end

  private

  def argument_params
    params.permit(:product_group_id, :feature, :benefit)
  end
end
