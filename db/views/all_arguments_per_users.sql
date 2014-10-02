CREATE OR REPLACE VIEW all_arguments_per_users AS
SELECT
  rt.team_id,
  rt.rater_id,
  rt.argument_id,
  rt.is_rated
FROM rating_table rt
WHERE
  rt.owner_id != rt.rater_id;
