class CreateAutologins < ActiveRecord::Migration
  def change
    create_table :autologins do |t|
      t.integer :user_id, null: false
      t.string :token, null: false
      t.datetime :expires_at
      t.timestamps
    end

    add_index :autologins, :user_id
    add_index :autologins, :expires_at
    add_index :autologins, :token, unique: true
  end
end
