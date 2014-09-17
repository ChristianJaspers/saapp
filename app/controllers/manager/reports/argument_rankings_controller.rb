class Manager::Reports::ArgumentRankingsController < Manager::ManagerController
  expose(:arguments) { current_user.team.arguments.order('cached_rating DESC NULLS LAST') }
end
