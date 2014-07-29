class CreateProductGroups < ActiveRecord::Migration
  def change
    create_table :product_groups do |t|
      t.string :name, null: false
      t.integer :owner_id, null: false
      t.timestamps
    end

    add_index :product_groups, [:owner_id]
    add_index :product_groups, [:name]
  end
end
