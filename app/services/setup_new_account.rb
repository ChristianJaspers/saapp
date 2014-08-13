class SetupNewAccount < BusinessProcess::Base
  needs :wizard

  delegate :raw_confirmation_token, to: :manager, prefix: true

  def call
    create_company and
        create_team and
        create_manager and
        create_product_groups_and_arguments and
        create_invitees and
        send_emails
  end

  private

  attr_reader :manager, :company, :team, :invitees

  def create_manager
    @manager = team.users.create(email: wizard.email) do |user|
      user.role = 'manager'
      user.skip_confirmation_notification!
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
        Array.wrap(wizard_product_group.arguments).each do |wizard_argument|
          product_group.arguments.create(feature: wizard_argument.feature,
                                         benefit: wizard_argument.benefit,
                                         owner_id: manager.id)
        end
      end
    end
  end

  def create_invitees
    @invitees = wizard.invitations.map do |invitation|
      team.users.build(email: invitation.email, display_name: invitation.display_name).tap do |invitee|
        invitee.skip_confirmation_notification!
        invitee.save
      end
    end
  end

  def send_emails
    manager.send_confirmation_instructions
    send_inivitations
  end

  def send_inivitations
    ApplicationMailer.user_invitation(*invitees)
  end
end
