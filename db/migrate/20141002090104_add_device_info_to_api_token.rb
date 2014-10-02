class AddDeviceInfoToApiToken < ActiveRecord::Migration
  def change
    add_column :api_tokens, :notification_token, :string
    add_column :api_tokens, :platform, :string

    add_index :api_tokens, :notification_token
  end
end
