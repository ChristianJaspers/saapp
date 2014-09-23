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
    restore_user = Manager::RestoreUser.new(user.email, current_user)

    if restore_user.find_user_to_restore_by_email
      if restore_user.call
        @user = restore_user.restoree
      else
        nil
      end
    else
      create_user
    end
  end

  def create_user
    user.skip_confirmation_notification!
    saved = user.save
  end

  def update_remote_subscription
    SubscriptionUpdater.call(user: user).success?
  end

  def send_invitation
    ApplicationMailer.user_invitation(user)
  end
end
