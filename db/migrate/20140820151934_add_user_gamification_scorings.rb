class AddUserGamificationScorings < ActiveRecord::Migration
  def up
    execute "CREATE VIEW user_gamification_scorings AS #{ File.read(Rails.root.join('db/views/user_gamification_scorings.sql')) }"
  end

  def down
    execute "DROP VIEW user_gamification_scorings"
  end
end
