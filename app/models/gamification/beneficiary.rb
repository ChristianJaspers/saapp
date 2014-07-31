module Gamification
  module Beneficiary
    extend ActiveSupport::Concern

    included do
      has_many :scorings, class_name: Gamification::Scoring, foreign_key: :beneficiary_id
    end

    def score_in_period
      score(period: Gamification::Scoring.comparison_period)
    end

    def score(period: nil)
      if period
        scorings.within_period(period).sum(:amount)
      else
        scorings.sum(:amount)
      end
    end

    def goal_score
      [max_score, average_score * 2].max
    end

    private

    def max_score
      scorings.within_period.group(:beneficiary_id).sum(:amount).values.max || 0
    end

    def average_score
      scorings.within_period.average(:amount).to_i
    end
  end
end
