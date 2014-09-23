class AddIsTestToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :is_test, :boolean
  end
end
