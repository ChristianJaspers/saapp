class Manager::CategoriesController < Manager::ManagerController
  expose(:categories, ancestor: :team) { |relation| relation.order(name: :asc).page(params[:page]) }

  layout 'manager'

  private

  def team
    current_user.team
  end
end
