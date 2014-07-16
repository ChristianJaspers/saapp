class AddTeamIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :team_id, :integer, null: false
  end
end
