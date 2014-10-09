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

    # create users for Apple approval
    selleo = Company.create!
    team = selleo.teams.create!
    selleo_users = [
      {role: 'manager', email: 'mobile@selleo.com', password: 'secret4manager'},
      {role: 'user', email: 'mobile+demo@selleo.com', password: '7Lf2XOoG'}
    ]
    selleo_users.each do |user_data|
      user = User.new(
        email: user_data[:email],
        password: user_data[:password],
        password_confirmation: user_data[:password],
        role: user_data[:role],
        team: team
      )
      user.skip_confirmation_notification!
      user.save
      user.confirm!
    end
    manager_email = selleo_users.detect {|x| x[:role] == 'manager' }[:email]
    Subscription.start_trial_for_manager(User.find_by_email(manager_email))
  end
end
