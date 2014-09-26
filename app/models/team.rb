class Team < ActiveRecord::Base
  include Gamification::Beneficiary

  belongs_to :company, inverse_of: :teams
  has_many :users, inverse_of: :team, dependent: :destroy
  has_many :sales_representatives, -> { where role: User.roles['user'] }, class_name: User
  has_many :product_groups, through: :users
  has_many :scorings, class_name: Gamification::Scoring, through: :users
  has_many :arguments, through: :product_groups

  def goal_score
    GoalLevelScore.for_team(self)
  end
end
