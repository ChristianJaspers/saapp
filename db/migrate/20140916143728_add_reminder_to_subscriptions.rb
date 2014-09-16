class AddReminderToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :send_reminder_at, :datetime
    add_index :subscriptions, :send_reminder_at
  end
end
