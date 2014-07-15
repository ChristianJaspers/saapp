class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.integer :owner_id, null: false
      t.timestamps
    end

    add_index :categories, [:owner_id]
    add_index :categories, [:name]
  end
end
