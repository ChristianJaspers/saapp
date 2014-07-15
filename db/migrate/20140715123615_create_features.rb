class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :description, null: false
      t.integer :category_id, null: false
      t.integer :owner_id, null: false

      t.timestamps
    end

    add_index :features, [:category_id]
    add_index :features, [:owner_id]
  end
end
