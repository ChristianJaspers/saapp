SELECT
  apt.*,
  u.id AS rater_id,
  ratings.id,
  (ratings.id IS NOT NULL) AS is_rated
FROM users u
INNER JOIN arguments_per_team apt ON apt.team_id = u.team_id
LEFT OUTER JOIN argument_ratings ratings ON ratings.argument_id = apt.argument_id AND ratings.rater_id = u.id;
