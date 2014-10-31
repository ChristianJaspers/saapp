class AllArgumentsPerUser < ActiveRecord::Base
  scope :for_user, -> (user) { where(rater_id: user.id) }
  scope :for_team, -> (team) { where(team_id: team.id) }
  scope :grouped_by_rater, -> { group(:rater_id).select('rater_id, SUM(CASE WHEN is_rated IS FALSE AND archived IS FALSE THEN 1 ELSE 0 END) AS unrated_arguments_count') }

  def self.send_to_user(user)
    PushNotifications::Sender.new(map_to_unrated_arguments_for_user(user)).send
  end

  def self.send_to_team(team)
    PushNotifications::Sender.new(map_to_unrated_arguments_for_team(team)).send
  end

  def unrated_arguments_count
    self[:unrated_arguments_count] || 0
  end

  def self.map_to_unrated_arguments_for_user(user)
    map_to_unrated_arguments(
      AllArgumentsPerUser.for_user(user).grouped_by_rater.all
    )
  end

  def self.map_to_unrated_arguments_for_team(team)
    map_to_unrated_arguments(
      AllArgumentsPerUser.for_team(team).grouped_by_rater.all
    )
  end

  private

  def self.map_to_unrated_arguments(scoped_unrated_arguments_per_user)
    scoped_unrated_arguments_per_user.inject({}) do |agg, val|
      agg[val.rater_id] = val.unrated_arguments_count
      agg
    end
  end
end
