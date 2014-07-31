class ApplicationMailer < ActionMailer::Base
  def user_invitation(*users)
    recipients = users.map do |user|
      EmailTemplates::Recipient.new(user.locale, user.email, {display_name: user.display_name, password: activate_user_with_generated_password(user)})
    end
    EmailTemplates::Sender.new(recipients, :user_invitation).send
  end

  def reset_user_password(user)
    EmailTemplates::Sender.new(
      EmailTemplates::Recipient.new(user.locale, user.email, {password: activate_user_with_generated_password(user)}), :reset_user_password
    ).send
  end

  private

  def activate_user_with_generated_password(user)
    user.activate_with_new_password!(password = GenerateRandomPassword.call)
    password
  end
end
