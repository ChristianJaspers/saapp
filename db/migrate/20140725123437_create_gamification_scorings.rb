class CreateGamificationScorings < ActiveRecord::Migration
  def change
    create_table :gamification_scorings do |t|
      t.integer :amount
      t.integer :beneficiary_id
      t.string :event_name

      t.timestamps
    end
  end
end
