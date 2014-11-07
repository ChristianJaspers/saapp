class Manager::DestroyArgument < BusinessProcess::Base
  extend BusinessProcess::Transactional
  transaction_for Argument

  needs :current_user
  needs :params

  attr_reader :argument

  def call
    find_argument and
      destroy_argument
  end

  def find_argument
    @argument = team_arguments.where(id: params[:id]).first
  end

  def destroy_argument
    argument.destroy
    argument.destroyed?
  end

  def team_arguments
    Argument.where(product_group_id: ProductGroup.where(team_id: current_user.team_id))
  end
end
