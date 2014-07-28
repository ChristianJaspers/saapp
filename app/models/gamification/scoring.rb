class Gamification::Scoring < ActiveRecord::Base
  scope :within_period, ->(range) { where('gamification_scorings.created_at >= :range_begin AND gamification_scorings.created_at <= :range_end',
                                          {range_begin: range.begin.to_s, range_end: range.end.to_s}) }
end
