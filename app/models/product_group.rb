class ProductGroup < ActiveRecord::Base
  include Model::DelayedDestroy

  belongs_to :owner, class_name: User, inverse_of: :product_groups
  belongs_to :team
  has_many :arguments, inverse_of: :product_group, dependent: :destroy

  delegate :count, to: :arguments, prefix: true

  validates :name, presence: true
  validates :team, presence: true

  scope :active_only, -> { where(archived_at: nil) }
  scope :sorted, -> { order(:position) }

  acts_as_list scope: :team

  before_validation :store_team_from_owner, on: :create

  def archive=(val)
    self.archived_at = val.eql?('true') ? Time.zone.now : nil
  end

  def removable_by?(user)
    arguments_count.zero? || owner_id == user.id
  end

  private

  def store_team_from_owner
    self.team_id = owner.team_id
  end
end
