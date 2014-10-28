class AddPositionToProductGroups < ActiveRecord::Migration
  def change
    add_column :product_groups, :position, :integer
  end
end
