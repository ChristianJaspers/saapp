class SubscriptionMailSender
  def self.subscription_gentle_reminder(user)
    recipient = prepare_recipient(user, {})
    EmailTemplates::Sender.new([recipient], :subscription_gentle_reminder).send
  end

  def self.subscription_critical_reminder(user)
    recipient = prepare_recipient(user, {})
    EmailTemplates::Sender.new([recipient], :subscription_critical_reminder).send
  end

  def self.subscription_trial_expired(user)
    recipient = prepare_recipient(user, {})
    EmailTemplates::Sender.new([recipient], :subscription_trial_expired).send
  end

  private

  def self.prepare_recipient(user, vars = {})
    EmailTemplates::Recipient.new(user.locale, user.email, vars)
  end
end
