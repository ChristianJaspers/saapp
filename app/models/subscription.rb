class Subscription < ActiveRecord::Base
  ENDS_WITHIN_WEEK_DURATION = 7.days
  TRIAL_DURATION = 30.days

  belongs_to :company
  belongs_to :referrer, class_name: User

  scope :active, -> { where(status: 'active').deos_not_end_yet }
  scope :trials, -> { where(reference: 'trial') }
  scope :deos_not_end_yet, -> { where('subscriptions.ends_at IS NULL OR subscriptions.ends_at > ?', Time.now) }
  scope :non_empty_end_date, -> { where('subscriptions.ends_at IS NOT NULL') }

  before_create :setup_week_reminder

  def self.start_trial_for_manager(manager)
    manager.company.subscriptions.build(
      reference: 'trial',
      referrer_id: manager.id,
      quantity: manager.sales_reps_count,
      status: 'active',
      ends_at: (Time.now + TRIAL_DURATION)
    ).save
  end

  def trial?
    reference == 'trial'
  end

  def active?
    status == 'active' && does_not_end_yet?
  end

  def ends_within_week?
    ends_within?(ENDS_WITHIN_WEEK_DURATION)
  end

  private

  def setup_week_reminder
    self.send_reminder_at = (ends_at - ENDS_WITHIN_WEEK_DURATION) if ends_at.present?
  end

  def ends_within?(duration)
    does_not_end_yet? && ends_at.present? && (Time.now + duration >= ends_at)
  end

  def does_not_end_yet?
    ends_at.blank? || ends_at > Time.now
  end
end
