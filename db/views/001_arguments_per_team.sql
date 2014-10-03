SELECT
  u.team_id,
  u.id AS owner_id,
  a.id AS argument_id
FROM arguments a
INNER JOIN users u on u.id = a.owner_id;
