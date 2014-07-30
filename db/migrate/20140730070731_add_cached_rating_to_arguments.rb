class AddCachedRatingToArguments < ActiveRecord::Migration
  def change
    add_column :arguments, :cached_rating, :float
  end
end
