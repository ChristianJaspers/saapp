class ApplicationMailer < ActionMailer::Base
  def user_invitation(*users)
    recipients = users.map do |user|
      EmailTemplates::Recipient.new(user.locale, user.email, {display_name: user.display_name})
    end
    EmailTemplates::Sender.new(recipients, :user_invitation).send
  end
end
