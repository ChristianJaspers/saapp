class AddRemoveAtToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :remove_at, :date
  end
end
