class SetupNewAccount < BusinessProcess::Base
  needs :wizard

  def call
    create_company and
        create_team and
        create_manager and
        create_product_groups_and_arguments and
        create_invitees and
        send_invitations
  end

  private

  attr_reader :manager, :company, :team, :invitees

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

  def create_product_groups_and_arguments
    wizard.product_groups.each do |wizard_product_group|
      manager.product_groups.create(name: wizard_product_group.name).tap do |product_group|
        wizard_product_group.arguments.each do |wizard_argument|
          product_group.arguments.create(feature: wizard_argument.argument,
                                         benefit: wizard_argument.benefit,
                                         owner_id: manager.id)
        end
      end
    end
  end

  def create_invitees
    @invitees = wizard.invitations.map do |invitation|
      team.users.create(email: invitation.email,
                        display_name: invitation.display_name,
                        password: 'fixme123')
    end
  end

  def send_invitations
    ApplicationMailer.user_invitation(*invitees)
  end
end
