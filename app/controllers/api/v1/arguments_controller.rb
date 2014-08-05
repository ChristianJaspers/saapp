class Api::V1::ArgumentsController < Api::RestrictedApplicationController
  def create
    product_group = current_user.team.product_groups.find_by_id(argument_params[:product_group_id])

    if product_group
      argument = product_group.arguments.build(argument_params.merge(owner_id: current_user.id))
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
    argument = current_user.team.arguments.find_by_id(params[:id])
    if argument
      if argument.owner_id == current_user.id
        if argument_params.key?(:product_group_id)
          product_group = current_user.team.product_groups.find_by_id(argument_params[:product_group_id])
          if product_group
            save_argument(argument)
          else
            render_fail_json(:missing_product_group)
          end
        else
          save_argument(argument)
        end
      else
        render_fail_json(:forbidden)
      end
    else
      render_fail_json(:argument_not_found)
    end
  end

  private

  def argument_params
    params.permit(:product_group_id, :feature, :benefit)
  end

  def save_argument(argument)
    argument.attributes = argument_params
    if argument.save
      render_json(ArgumentRating.new(argument: argument, rater: current_user), 201, serializer: Api::ArgumentRatingSerializer)
    else
      render_fail_json(:missing_feature_or_benefit)
    end
  end
end
