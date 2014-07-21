class Category < ActiveRecord::Base
  belongs_to :owner, class_name: User, inverse_of: :categories
  has_many :features, inverse_of: :category

  delegate :count, to: :features, prefix: true
end
