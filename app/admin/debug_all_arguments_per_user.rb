ActiveAdmin.register AllArgumentsPerUser do
  menu false

  actions :index

  controller do
    def scoped_collection
      company = Company.find(params[:company_id])
      team = company.teams.first
      AllArgumentsPerUser.for_team(team).grouped_by_rater.all
    end
  end

  index do
    column 'User email' do |rate|
      rater = User.unscoped.find_by(id: rate.rater_id)

      if rater
        "#{rater.email}#{ rater.remove_at.present? ? " (user will be deleted at: #{rater.remove_at})" : nil }"
      else
        'User deleted'
      end
    end
    column 'Unrated arguments' do |rate|
      rate.unrated_arguments_count
    end
  end
end
