class CreateBenefits < ActiveRecord::Migration
  def change
    create_table :benefits do |t|
      t.string :description, null: false
      t.integer :feature_id, null: false

      t.timestamps
    end

    add_index :benefits, [:feature_id]
  end
end
