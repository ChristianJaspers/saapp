class AddArchivedAtToProductGroups < ActiveRecord::Migration
  def change
    add_column :product_groups, :archived_at, :datetime
  end
end
