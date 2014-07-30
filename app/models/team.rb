class Team < ActiveRecord::Base
  include Gamification::Beneficiary

  belongs_to :company, inverse_of: :teams
  has_many :users, inverse_of: :team
  has_many :sales_representatives, -> { where role: User.roles['user'] }, class_name: User
  has_many :product_groups, through: :users
  has_many :scorings, class_name: Gamification::Scoring, through: :users
  has_many :arguments, through: :product_groups

  def goal_score
    [max_team_score, average_team_score * 2].max
  end

  def self.comparison_period
    ((Date.today.beginning_of_day-7.days)..Date.today.end_of_day)
  end

  private

  def max_team_score
    scorings.within_period(Team.comparison_period).group(:beneficiary_id).sum(:amount).values.max || 0
  end

  def average_team_score
    scorings.within_period(Team.comparison_period).average(:amount).to_i
  end
end
