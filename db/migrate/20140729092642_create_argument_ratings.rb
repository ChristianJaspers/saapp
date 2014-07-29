class CreateArgumentRatings < ActiveRecord::Migration
  def change
    create_table :argument_ratings do |t|
      t.integer :argument_id
      t.integer :rater_id
      t.integer :rating

      t.timestamps
    end
  end
end
