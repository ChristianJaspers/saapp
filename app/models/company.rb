class Company < ActiveRecord::Base
  include Gamification::Beneficiary

  has_many :teams, inverse_of: :company
  has_many :users, through: :teams
  has_many :scorings, class_name: Gamification::Scoring, through: :users
  has_many :sales_representatives, through: :teams

  def sales_reps_count
    sales_representatives.count
  end

  def self.overall_goal_score
    GoalLevelScore.for_platform
  end

  def goal_score
    GoalLevelScore.for_company(self)
  end
end
