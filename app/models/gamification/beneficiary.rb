module Gamification
  module Beneficiary
    extend ActiveSupport::Concern

    included do
      has_many :scorings, class_name: Gamification::Scoring, foreign_key: :beneficiary_id
    end
  end
end
