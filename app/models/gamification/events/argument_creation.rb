# By default points go to current_user, which is called on updated object
# to: and if: methods, if provided with symbols, will be called on updated object
#
# class Gamification::Events::ArgumentRating
#   grant_points 2
#   grant_points 2, to: :argument_creator, if: :moderate?
#   grant_points 4, to: :argument_creator, if: :high?
# end

module Gamification
  module Events
    class ArgumentCreation < Base
      grant_points 2, to: :owner
    end
  end
end
