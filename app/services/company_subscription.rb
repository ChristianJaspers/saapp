class CompanySubscription
  attr_reader :current_user

  delegate :company, to: :current_user, allow_nil: true

  def initialize(current_user)
    @current_user = current_user
  end

  def can_use_system?
    !!active_subscription
  end

  def needs_to_buy_subscription?
    if active_remote_subscription
      # if ends_at presents then your subscription will be over soon, you need to buy new one
      active_remote_subscription.ends_at.present?
    else
      true
    end
  end

  def any_remote_subscription
    if_company do
      @any_remote_subscription ||= company.subscriptions.remote_subscriptions.limit(1).order('ends_at DESC NULLS FIRST, id DESC').first
    end
  end

  def display_reminder?
    active_subscription && active_subscription.trial? && (active_subscription.ends_within_week? || active_subscription.expired?)
  end

  def link_negotiator
    @link_negotiator ||= Saasy::BillingLinkNegotiator.new(self)
  end

  def billing_form
    @billing_form ||= Saasy::BillingForm.new(current_user)
  end

  # determines if user can use system
  def active_subscription
    if_company do
      @active_subscription ||= company.subscriptions.active.limit(1).order('ends_at DESC NULLS FIRST, id DESC').first
    end
  end

  # determines if user should buy subscription
  def active_remote_subscription
    if_company do
      @active_remote_subscription ||= company.subscriptions.active_remote.limit(1).order('ends_at DESC NULLS FIRST, id DESC').first
    end
  end

  private

  def if_company
    company ? yield : nil
  end
end
