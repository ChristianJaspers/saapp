CREATE OR REPLACE VIEW unrated_arguments_per_users AS
SELECT
  rt.team_id,
  rt.rater_id,
  rt.argument_id
FROM rating_table rt
WHERE
  rt.owner_id != rt.rater_id AND
  rt.is_rated IS FALSE;
