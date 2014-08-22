module Gamification
  module Shared
    module Periodable
      extend ActiveSupport::Concern

      included do
        scope :within_period, ->(*args) do
          range = args.shift || comparison_period
          where("#{self.table_name}.created_at BETWEEN ? AND ?", range.begin.to_s, range.end.to_s)
        end
      end

      module ClassMethods
        def comparison_period
          ((Date.today.beginning_of_day - 7.days)..Date.today.end_of_day)
        end
      end
    end
  end
end
