class Category < ActiveRecord::Base
  belongs_to :owner, class_name: User, inverse_of: :categories
  has_many :features, inverse_of: :category, dependent: :destroy

  delegate :count, to: :features, prefix: true

  def archive=(val)
    self.archived_at = val.eql?('true') ? Time.zone.now : nil
  end
end
