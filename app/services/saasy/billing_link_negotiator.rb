class Saasy::BillingLinkNegotiator
  attr_reader :subscription

  def initialize(user)
    @subscription = user.company.subscriptions.active_remote.first
  end

  def link
    if render_form?
      submit_form_link
    else
      saasy_subscription_link
    end
  end

  def render_form?
    !subscription
  end

  private

  def submit_form_link
    "javascript:$('#external_billing_system').submit()"
  end

  def saasy_subscription_link
    Rails.application.routes.url_helpers.saasy_subscription_path(subscription.reference)
  end
end
