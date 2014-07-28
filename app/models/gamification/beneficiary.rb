module Gamification
  module Beneficiary
    extend ActiveSupport::Concern

    included do
      has_many :scorings, class_name: Gamification::Scoring, foreign_key: :beneficiary_id
    end

    def score(period: nil)
      if period
        scorings.within_period(period).sum(:amount)
      else
        scorings.sum(:amount)
      end
    end
  end
end
