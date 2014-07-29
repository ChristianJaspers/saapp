class AddCounterCacheToProductGroups < ActiveRecord::Migration
  def change
    add_column :product_groups, :arguments_count, :integer
  end
end
