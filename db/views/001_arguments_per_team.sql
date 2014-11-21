SELECT
  u.team_id,
  u.id AS owner_id,
  a.id AS argument_id,
  pg.id AS product_group_id,
  pg.archived_at AS product_group_archived_at
FROM arguments a
INNER JOIN product_groups pg ON pg.id = a.product_group_id
INNER JOIN users u ON u.id = a.owner_id
WHERE pg.remove_at IS NULL;
