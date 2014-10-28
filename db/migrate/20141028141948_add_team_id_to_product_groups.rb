class AddTeamIdToProductGroups < ActiveRecord::Migration
  def change
    add_column :product_groups, :team_id, :integer
    add_index :product_groups, :team_id
  end
end
