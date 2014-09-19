namespace :subscriptions do
  desc 'Sends subscriptions reminders'
  task send_trial_expiration_reminders: :environment do
    Subscription.to_be_sent_as_reminders.each do |subscription|
      subscription.send_reminder!
    end
  end
end
