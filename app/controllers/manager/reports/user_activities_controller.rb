class Manager::Reports::UserActivitiesController < Manager::ManagerController
  layout 'manager'

  expose(:users) { current_user.team.sales_representatives.order(:email) }
end
