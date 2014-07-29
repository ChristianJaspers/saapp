class AddRemoveAtToProductGroups < ActiveRecord::Migration
  def change
    add_column :product_groups, :remove_at, :date
  end
end
