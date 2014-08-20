class UserGamificationScoring < ActiveRecord::Base
  def self.results_for_company_user(user)
    where(company_id: User.last, role: User.roles[:user]).
      group(:id, :email, :display_name).
      order('score DESC').
      select('id, email, display_name, SUM(amount) AS score')
  end
end
