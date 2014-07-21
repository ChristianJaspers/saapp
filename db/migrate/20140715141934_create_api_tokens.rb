class CreateApiTokens < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.integer :user_id
      t.string :access_token, null: false
      t.timestamps
    end

    add_index :api_tokens, :access_token, unique: true
    add_index :api_tokens, :user_id
  end
end
