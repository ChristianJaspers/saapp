class Manager::CreateUser < BusinessProcess::Base
  needs :user
  needs :current_user

  def call
    create_or_restore_user and
      update_remote_subscription and
      send_invitation
  end

  private

  def create_or_restore_user
    @user_to_process = user
    restore_user = Manager::RestoreUser.new(user.email, current_user)

    if restore_user.find_user_to_restore_by_email
      if restore_user.call
        @user_to_process = restore_user.restoree
      else
        nil
      end
    else
      create_user
    end
  end

  def create_user
    user_to_process.skip_confirmation_notification!
    user_to_process.save
  end

  def update_remote_subscription
    SubscriptionUpdater.call(user: user_to_process).success?
  end

  def send_invitation
    ApplicationMailer.user_invitation(user_to_process)
  end

  private

  attr_reader :user_to_process
end
