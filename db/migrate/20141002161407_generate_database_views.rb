class GenerateDatabaseViews < ActiveRecord::Migration
  VIEWS = %w[
    user_gamification_scorings
    arguments_per_team
    rating_table
    all_arguments_per_users
  ]

  def up
    VIEWS.each do |view|
      execute File.read(Rails.root.join('db', 'views', "#{view}.sql").to_s)
    end
  end

  def down
    VIEWS.reverse.each do |view|
      execute "DROP VIEW #{view};"
    end
  end
end
