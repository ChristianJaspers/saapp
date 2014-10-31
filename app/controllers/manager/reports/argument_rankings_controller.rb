class Manager::Reports::ArgumentRankingsController < Manager::ManagerController
  expose_decorated(:arguments, decorator: ReportArgumentRankingDecorator, collection: true) do
    current_user.team.arguments.includes(:product_group).order('cached_rating DESC NULLS LAST')
  end
end
