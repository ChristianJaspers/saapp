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
end
