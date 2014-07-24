class Benefit < ActiveRecord::Base
  belongs_to :feature, inverse_of: :benefit

  validates :description, presence: true
end
