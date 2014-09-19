class Subscription < ActiveRecord::Base
  ENDS_WITHIN_WEEK_DURATION = 7.days
  ENDS_WITHIN_FEW_DAYS_DURATION = 2.days
  TRIAL_DURATION = 30.days

  belongs_to :company
  belongs_to :referrer, class_name: User

  scope :active_remote, -> { remote_subscriptions.active }
  scope :active, -> { where(status: 'active').deos_not_end_yet }
  scope :trials, -> { where(reference: 'trial') }
  scope :remote_subscriptions, -> { where.not(reference: 'trial') }
  scope :deos_not_end_yet, -> { where('subscriptions.ends_at IS NULL OR subscriptions.ends_at > ?', Time.now) }
  scope :non_empty_end_date, -> { where('subscriptions.ends_at IS NOT NULL') }
  scope :to_be_sent_as_reminders, -> { trials.where('subscriptions.send_reminder_at <= ?', Time.now) }

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

  def ends_within_few_days?
    ends_within?(ENDS_WITHIN_FEW_DAYS_DURATION)
  end

  def send_reminder!
    if ends_at.present?
      if Time.now >= ends_at
        update_column(:send_reminder_at, nil)
      elsif ends_within_few_days?
        update_column(:send_reminder_at, ends_at + 1.hour)
      elsif ends_within_week?
        update_column(:send_reminder_at, ends_at - ENDS_WITHIN_FEW_DAYS_DURATION)
      end
    end
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
