class Company < ActiveRecord::Base
  include Gamification::Beneficiary
  include Model::DelayedDestroy

  has_many :teams, inverse_of: :company, dependent: :destroy
  has_many :users, through: :teams
  has_many :scorings, class_name: Gamification::Scoring, through: :users
  has_many :sales_representatives, through: :teams
  has_many :subscriptions, dependent: :destroy

  scope :to_be_sent_as_reminders, -> { where('companies.send_removal_reminder_at <= ?', Time.now) }

  def send_removal_reminder!
    SubscriptionMailSender.account_will_be_deleted(first_manager, payment_url)
    clear_removal_reminder!
  end

  def lifetime_before_is_removed
    30.days
  end

  def sales_reps_count
    sales_representatives.count
  end

  def self.overall_goal_score
    GoalLevelScore.for_platform
  end

  def goal_score
    GoalLevelScore.for_company(self)
  end

  alias_method :original_remove_at!, :remove_at!
  alias_method :original_do_not_remove!, :do_not_remove!

  def do_not_remove!
    clear_removal_reminder!
    original_do_not_remove!
  end

  def remove_at!(date)
    update_column(:send_removal_reminder_at, date - 7.days)
    original_remove_at!(date)
  end

  def to_s
    "Company ##{id}"
  end

  private

  def first_manager
    @first_manager ||= users.managers.first
  end

  def payment_url
    Saasy::BillingForm.new(first_manager).payment_url
  end

  def clear_removal_reminder!
    update_column(:send_removal_reminder_at, nil)
  end
end
