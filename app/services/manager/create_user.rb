class Manager::CreateUser < BusinessProcess::Base
  needs :user
  needs :current_user

  def call
    assign_user_to_process and
    create_or_restore_user and
      update_remote_subscription and
      send_invitation
  end

  private

  def assign_user_to_process
    self.user_to_process = user
  end

  def create_or_restore_user
    restore_user = Manager::RestoreUser.new(user_to_process.email, current_user)

    if restore_user.find_user_to_restore_by_email
      if restore_user.call
        self.user_to_process = restore_user.restoree
      else
        nil
      end
    else
      create_user
    end
  end

  def create_user
    user_to_process.locale = current_user.locale
    user_to_process.skip_confirmation_notification!
    user_to_process.save
  end

  def update_remote_subscription
    SubscriptionUpdater.call(user: user_to_process).success?
  end

  def send_invitation
    ApplicationMailer.user_invitation(user_to_process)
  end

  attr_accessor :user_to_process
end
