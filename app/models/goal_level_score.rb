class GoalLevelScore
  def self.for_platform
    UserGamificationScoring.from(
      UserGamificationScoring.within_period.
        group(:id).
        select('SUM(COALESCE(amount, 0)) AS total').
        as('score')
    ).select('AVG(score.total) AS average').first.try(:average).to_f * 2
  end

  def self.for_company(company)
    [
      UserGamificationScoring.from(
        UserGamificationScoring.within_period.
          where(company_id: company.id).
          group(:id).
          select('SUM(COALESCE(amount, 0)) AS total').
          as('score')
      ).select('MAX(score.total) AS maximum').first.try(:maximum).to_f,
      UserGamificationScoring.from(
        UserGamificationScoring.within_period.
          where(company_id: company.id).
          group(:id).
          select('SUM(COALESCE(amount, 0)) AS total').
          as('score')
      ).select('AVG(score.total) AS average').first.try(:average).to_f * 2
    ].max
  end

  def self.for_team(team)
    [
      UserGamificationScoring.from(
        UserGamificationScoring.within_period.
          where(team_id: team.id).
          group(:id).
          select('SUM(COALESCE(amount, 0)) AS total').
          as('score')
      ).select('MAX(score.total) AS maximum').first.try(:maximum).to_f,
      UserGamificationScoring.from(
        UserGamificationScoring.within_period.
          where(team_id: team.id).
          group(:id).
          select('SUM(COALESCE(amount, 0)) AS total').
          as('score')
      ).select('AVG(score.total) AS average').first.try(:average).to_f * 2
    ].max
  end

  def self.my_team_activity(team)
    team_stats = UserGamificationScoring.within_period.
      where('team_id = ?', team.id).
      group('id').
      select('id, SUM(amount) AS amount')

    # this query does not need scopes since it's already scoped in team_stats above
    target_stats = UserGamificationScoring.from('team_stats').
      select('id, COALESCE(amount, 0) * 100.0 / MAX(amount) OVER () AS user_activity_in_team')

    UserGamificationScoring.find_by_sql(%{
      WITH team_stats AS (
        #{ team_stats.to_sql }
      ), target_stats AS (
        #{ target_stats.to_sql }
      )
      SELECT AVG(user_activity_in_team) AS my_team_activity FROM target_stats
    }).first.try(:my_team_activity).to_f
  end
end
