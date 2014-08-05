class Api::UpdateArgument < BusinessProcess::Base
  include BusinessProcess::Errorable
  extend BusinessProcess::Transactional
  transaction_for Argument

  needs :argument_params
  needs :params
  needs :current_user

  def call
    find_argument and
      validate_owner and
      check_for_product_group_change and
      update_argument and
      prepare_result
  end

  private

  attr_reader :product_group, :argument

  def find_argument
    check_for_error :argument_not_found do
      @argument = current_user.team.arguments.find_by_id(params[:id])
    end
  end

  def validate_owner
    check_for_error :forbidden do
      argument.owner_id == current_user.id
    end
  end

  def check_for_product_group_change
    check_for_error :missing_product_group do
      if argument_params.key?(:product_group_id)
        @product_group = current_user.team.product_groups.find_by_id(argument_params[:product_group_id])
      else
        true
      end
    end
  end

  def update_argument
    check_for_error :missing_feature_or_benefit do
      argument.attributes = argument_params
      argument.save
    end
  end

  def prepare_result
    ArgumentRating.new(argument: argument, rater: current_user)
  end
end
