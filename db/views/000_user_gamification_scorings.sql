SELECT
  usr.id,
  t.company_id,
  usr.team_id,
  usr.role,
  usr.email,
  usr.display_name,
  scoring.amount,
  scoring.event_name,
  scoring.created_at
FROM users AS usr
INNER JOIN teams AS t ON t.id = usr.team_id
LEFT OUTER JOIN gamification_scorings AS scoring ON scoring.beneficiary_id = usr.id
