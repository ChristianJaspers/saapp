namespace :system do
  desc 'Deletes all data except super admin and cms data'
  task delete_everything_except_admin_and_cms: :environment do
    admin = User.unscoped.admin.first
    team = admin.team
    company = team.company

    User.transaction do
      ApiToken.unscoped.delete_all
      Gamification::Scoring.unscoped.delete_all
      ArgumentRating.unscoped.delete_all
      Argument.unscoped.delete_all
      ProductGroup.unscoped.delete_all
      User.unscoped.where('id != ?', admin.id).delete_all
      Team.unscoped.where('id != ?', team.id).delete_all
      Company.unscoped.where('id != ?', company.id).delete_all
      Subscription.unscoped.delete_all
    end
  end
end
