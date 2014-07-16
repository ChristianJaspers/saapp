class Team < ActiveRecord::Base
  belongs_to :company, inverse_of: :teams
  has_many :users, inverse_of: :team
end