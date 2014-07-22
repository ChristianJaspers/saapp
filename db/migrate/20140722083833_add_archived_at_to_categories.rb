class AddArchivedAtToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :archived_at, :datetime
  end
end
