class Benefit < ActiveRecord::Base
  belongs_to :feature, inverse_of: :benefit
end
