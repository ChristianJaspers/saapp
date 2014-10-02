class Api::CreateArgument < BusinessProcess::Base
  include BusinessProcess::Errorable
  extend BusinessProcess::Transactional
  transaction_for Argument

  needs :argument_params
  needs :current_user

  def call
    find_product_group and
      create_argument and
      send_push_notification_to_team and
      prepare_result
  end

  private

  attr_reader :product_group, :argument

  def prepare_result
    ArgumentRating.new(argument: argument, rater: current_user)
  end

  def send_push_notification_to_team
    AllArgumentsPerUser.send_to_team(current_user.team)
    true
  end

  def create_argument
    check_for_error :missing_feature_or_benefit do
      @argument ||= product_group.arguments.build(argument_params.merge(owner_id: current_user.id))
      argument.save
    end
  end

  def find_product_group
    check_for_error :missing_product_group do
      @product_group ||= current_user.team.product_groups.find_by_id(argument_params[:product_group_id])
    end
  end
end
