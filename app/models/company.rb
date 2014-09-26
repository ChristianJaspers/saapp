class Company < ActiveRecord::Base
  include Gamification::Beneficiary
  include Model::DelayedDestroy

  has_many :teams, inverse_of: :company, dependent: :destroy
  has_many :users, through: :teams
  has_many :scorings, class_name: Gamification::Scoring, through: :users
  has_many :sales_representatives, through: :teams
  has_many :subscriptions, dependent: :destroy

  def lifetime_before_is_removed
    90.days
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

  def to_s
    "Company ##{id}"
  end
end
