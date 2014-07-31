class Company < ActiveRecord::Base
  include Gamification::Beneficiary

  has_many :teams, inverse_of: :company
  has_many :users, through: :teams
  has_many :scorings, class_name: Gamification::Scoring, through: :users

  def self.overall_goal_score
    Gamification::Scoring.within_period.average(:amount).to_i * 2
  end
end
