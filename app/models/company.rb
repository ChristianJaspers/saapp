class Company < ActiveRecord::Base
  include Gamification::Beneficiary
  include Model::DelayedDestroy

  has_many :teams, inverse_of: :company, dependent: :destroy
  has_many :users, through: :teams
  has_many :scorings, class_name: Gamification::Scoring, through: :users
  has_many :sales_representatives, through: :teams
  has_many :subscriptions, dependent: :destroy

  def lifetime_before_is_removed
    30.days
  end

  def sales_reps_count
    sales_representatives.count
  end

  def self.overall_goal_score
    GoalLevelScore.for_platform
  end

  def goal_score
    GoalLevelScore.for_company(self)
  end

  alias_method :original_remove_at!, :remove_at!
  alias_method :original_do_not_remove!, :do_not_remove!

  def do_not_remove!
    update_column(:send_removal_reminder_at, nil)
    original_do_not_remove!
  end

  def remove_at!(date)
    update_column(:send_removal_reminder_at, date - 7.days)
    original_remove_at!(date)
  end

  def to_s
    "Company ##{id}"
  end
end
