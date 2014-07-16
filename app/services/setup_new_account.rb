class SetupNewAccount < BusinessProcess::Base
  needs :wizard

  def call
    create_company and
        create_team and
        create_manager and
        create_categories_and_arguments and
        create_invitees
  end

  private

  attr_reader :manager, :company, :team

  def create_manager
    @manager = team.users.create(email: wizard.email, password: 'fixme123') do |user|
      user.role = 'manager'
    end
  end

  def create_company
    @company = Company.create
  end

  def create_team
    @team = company.teams.create
  end

  def create_categories_and_arguments
    wizard.categories.each do |wizard_category|
      manager.categories.create(name: wizard_category.name).tap do |category|
        wizard_category.arguments.each do |wizard_argument|
          category.features.create(description: wizard_argument.feature, owner_id: manager.id).tap do |feature|
            feature.create_benefit(description: wizard_argument.benefit)
          end
        end
      end
    end
  end

  def create_invitees
    wizard.invitations.each do |invitation|
      team.users.create(email: invitation.email,
                        display_name: invitation.display_name,
                        password: 'fixme123')
    end
  end
end
