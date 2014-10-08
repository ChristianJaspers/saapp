class SetupNewAccount < BusinessProcess::Base
  include BusinessProcess::Errorable
  extend BusinessProcess::Transactional
  transaction_for User

  needs :wizard

  delegate :raw_confirmation_token, to: :manager, prefix: true

  def call
    create_company and
        create_team and
        create_manager and
        create_product_groups_and_arguments and
        create_invitees and
        create_trial_subscription and
        send_emails
  end

  private

  attr_reader :manager, :company, :team, :invitees

  def create_manager
    check_for_error :manager_not_created do
      @manager = team.users.create(email: wizard.email) do |user|
        user.role = 'manager'
        user.locale = I18n.locale
        user.skip_confirmation_notification!
      end
      manager.persisted?
    end
  end

  def create_company
    check_for_error :company_not_created do
      @company = Company.create
      company.persisted?
    end
  end

  def create_team
    check_for_error :team_not_created do
      @team = company.teams.create
      team.persisted?
    end
  end

  def create_product_groups_and_arguments
    wizard.product_groups.each do |wizard_product_group|
      check_for_error :product_group_not_created do
        manager.product_groups.create(name: wizard_product_group.name).tap do |product_group|
          Array.wrap(wizard_product_group.arguments).each do |wizard_argument|
            check_for_error :argument_not_created do
              product_group.arguments.create(feature: wizard_argument.feature,
                                             benefit: wizard_argument.benefit,
                                             owner_id: manager.id).persisted?
            end
          end
        end.persisted?
      end
    end
  end

  def create_invitees
    @invitees = wizard.invitations.map do |invitation|
      invitee = nil
      check_for_error :invitee_not_created do
        invitee = team.users.build(
          email: invitation.email,
          display_name: invitation.display_name,
          invitation_message: wizard.invitation_message,
          locale: manager.locale
        ).tap do |invitee|
          invitee.skip_confirmation_notification!
          invitee.save
        end
        invitee.persisted?
      end
      invitee.persisted? ? invitee : nil
    end
    !invitees.any? { |invitee| invitee.nil? }
  end

  def create_trial_subscription
    Subscription.start_trial_for_manager(manager)
  end

  def send_emails
    AccountActivationJobManager.new(manager).create_job
    send_inivitations
  end

  def send_inivitations
    ApplicationMailer.user_invitation(*invitees)
  end
end
