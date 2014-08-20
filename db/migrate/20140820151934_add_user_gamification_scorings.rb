class AddUserGamificationScorings < ActiveRecord::Migration
  def up
    create_view :user_gamification_scorings, File.read(Rails.root.join('db/views/user_gamification_scorings.sql'))
  end

  def down
    drop_view :user_gamification_scorings
  end
end
