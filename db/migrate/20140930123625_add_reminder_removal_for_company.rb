class AddReminderRemovalForCompany < ActiveRecord::Migration
  def change
    add_column :companies, :send_removal_reminder_at, :datetime
  end
end
