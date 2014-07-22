class AddRemoveAtToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :remove_at, :date
  end
end
