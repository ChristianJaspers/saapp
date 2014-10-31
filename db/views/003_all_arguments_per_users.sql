SELECT
  rt.team_id,
  rt.rater_id,
  rt.argument_id,
  rt.is_rated,
  CASE WHEN rt.product_group_archived_at IS NOT NULL THEN
    TRUE
  ELSE
    FALSE
  END AS archived
FROM rating_table rt
WHERE
  rt.owner_id != rt.rater_id;
