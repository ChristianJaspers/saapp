class Feature < ActiveRecord::Base
  belongs_to :owner, class_name: User, inverse_of: :features
  belongs_to :category, inverse_of: :features
  has_one :benefit, inverse_of: :feature
end
