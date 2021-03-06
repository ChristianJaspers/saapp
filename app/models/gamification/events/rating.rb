module Gamification
  module Events
    class Rating < Base
      grant_points 5, to: :rater
      grant_points 2, to: :argument_owner, if: :medium?
      grant_points 4, to: :argument_owner, if: :high?
    end
  end
end
