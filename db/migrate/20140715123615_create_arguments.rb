class CreateArguments < ActiveRecord::Migration
  def change
    create_table :arguments do |t|
      t.string :feature, null: false
      t.string :benefit, null: false
      t.integer :product_group_id, null: false
      t.integer :owner_id, null: false
      t.timestamps
    end

    add_index :arguments, [:product_group_id]
    add_index :arguments, [:owner_id]
  end
end
