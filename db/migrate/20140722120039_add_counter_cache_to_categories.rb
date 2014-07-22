class AddCounterCacheToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :features_count, :integer
  end
end
