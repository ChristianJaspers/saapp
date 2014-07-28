class Team < ActiveRecord::Base
  include Gamification::Beneficiary

  belongs_to :company, inverse_of: :teams
  has_many :users, inverse_of: :team
  has_many :categories, through: :users
  has_many :scorings, class_name: Gamification::Scoring, through: :users

  def goal_score
    [max_team_score, average_team_score * 2].max
  end

  def comparison_period
    ((Date.today.beginning_of_day-7.days)..Date.today.end_of_day)
  end

  private

  def max_team_score
    scorings.within_period(comparison_period).group(:beneficiary_id).sum(:amount).values.max || 0
  end

  def average_team_score
    scorings.within_period(comparison_period).average(:amount).to_i
  end
end
