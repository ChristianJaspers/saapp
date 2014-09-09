class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :company_id
      t.string :reference
      t.integer :referrer_id
      t.integer :quantity
      t.string :status
      t.timestamps
    end

    add_index :subscriptions, :company_id
    add_index :subscriptions, :reference
    add_index :subscriptions, :referrer_id
    add_index :subscriptions, :status
  end
end
