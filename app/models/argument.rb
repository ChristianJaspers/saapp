class Argument < ActiveRecord::Base
  include Gamification::Gamified

  belongs_to :owner, class_name: User, inverse_of: :arguments
  belongs_to :product_group, inverse_of: :arguments, counter_cache: true
  has_many :ratings,
           class_name: ArgumentRating,
           inverse_of: :argument,
           dependent: :destroy,
           after_add: :cache_rating

  validates :feature, :benefit, presence: true

  gamify :creation, as: :argument_creation

  alias_attribute :rating, :cached_rating

  def rated?
    !rating.nil?
  end

  def clear_rating?
    %w(feature benefit).any? { |key| previous_changes.has_key?(key) }
  end

  def clear_rating!
    ratings.destroy_all
    update_column(:cached_rating, nil)
  end

  private

  def cache_rating(*)
    update_column(:cached_rating, ratings.average(:rating).to_f)
  end
end
