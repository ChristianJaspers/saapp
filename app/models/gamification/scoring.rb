class Gamification::Scoring < ActiveRecord::Base
  def self.comparison_period
    ((Date.today.beginning_of_day-7.days)..Date.today.end_of_day)
  end

  scope :within_period, ->(*args) do
    range = args.shift || Gamification::Scoring.comparison_period
    where('gamification_scorings.created_at >= :range_begin AND gamification_scorings.created_at <= :range_end',
          {range_begin: range.begin.to_s, range_end: range.end.to_s})
  end
end
