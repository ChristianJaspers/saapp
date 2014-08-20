class Manager::Reports::UserActivitiesController < Manager::ManagerController
  layout 'manager'

  expose(:users) { UserGamificationScoring.results_for_company_user(current_user) }
end
