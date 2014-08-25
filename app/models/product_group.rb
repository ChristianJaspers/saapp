class ProductGroup < ActiveRecord::Base
  include Model::DelayedDestroy

  belongs_to :owner, class_name: User, inverse_of: :product_groups
  has_many :arguments, inverse_of: :product_group, dependent: :destroy

  delegate :count, to: :arguments, prefix: true

  validates :name, presence: true

  scope :active_only, -> { where(archived_at: nil) }

  def archive=(val)
    self.archived_at = val.eql?('true') ? Time.zone.now : nil
  end

  def removable_by?(user)
    arguments_count.zero? || owner_id == user.id
  end
end
