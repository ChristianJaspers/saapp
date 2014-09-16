class AddEndsAtToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :ends_at, :datetime
    add_index :subscriptions, :ends_at
  end
end
