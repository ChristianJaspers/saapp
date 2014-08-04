class AddRemoveAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remove_at, :date
  end
end
