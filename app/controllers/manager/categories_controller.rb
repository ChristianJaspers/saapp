class Manager::CategoriesController < Manager::ManagerController
  expose(:categories, ancestor: :team) { |relation| relation.order(name: :asc).page(params[:page]) }

  private

  def team
    current_user.team
  end
end
