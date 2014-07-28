class SetupNewAccount < BusinessProcess::Base
  needs :wizard

  def call
    create_company and
        create_team and
        create_manager and
        create_categories_and_arguments and
        create_invitees and
        send_invitations
  end

  private

  attr_reader :manager, :company, :team, :invitees

  def create_manager
    @manager = team.users.create(email: wizard.email) do |user|
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
    @invitees = wizard.invitations.map do |invitation|
      invitee = team.users.new(email: invitation.email,
                        display_name: invitation.display_name)
      invitee.skip_confirmation_notification!
      invitee.save
      invitee
    end
  end

  def send_invitations
    ApplicationMailer.user_invitation(*invitees)
  end
end
