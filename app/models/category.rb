class Category < ActiveRecord::Base
  belongs_to :owner, class_name: User, inverse_of: :categories
  has_many :features, inverse_of: :category, dependent: :destroy

  delegate :count, to: :features, prefix: true

  validates :name, presence: true

  default_scope -> { where(remove_at: nil) }

  def archive=(val)
    self.archived_at = val.eql?('true') ? Time.zone.now : nil
  end

  def removable_by?(user)
    features_count.zero? || owner_id == user.id
  end

  def remove!
    update_column(:remove_at, Date.today + 30.days)
  end

  def self.purge_outdated_entries!
    unscoped.where('remove_at <= ?', Date.today.to_s(:db)).destroy_all
  end
end
