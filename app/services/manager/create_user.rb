class Manager::CreateUser < BusinessProcess::Base
  needs :user

  def call
    create_user and
      send_invitation
  end

  private

  def create_user
    user.skip_confirmation_notification!
    user.save
  end

  def send_invitation
    ApplicationMailer.user_invitation(user)
  end
end
