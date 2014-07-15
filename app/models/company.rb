class Company < ActiveRecord::Base
  has_many :teams, inverse_of: :company
end
