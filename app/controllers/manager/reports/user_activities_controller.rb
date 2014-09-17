class Manager::Reports::UserActivitiesController < Manager::ManagerController
  expose(:users) { UserGamificationScoring.results_for_company_user(current_user) }
end
