class Feature < ActiveRecord::Base
  include Gamification::Gamified

  belongs_to :owner, class_name: User, inverse_of: :features
  belongs_to :category, inverse_of: :features, counter_cache: true
  has_one :benefit, inverse_of: :feature, dependent: :destroy

  validates :description, presence: true

  gamify :creation, as: :argument_creation

  def rated?
    false #FIXME Implementation pending
  end
end
