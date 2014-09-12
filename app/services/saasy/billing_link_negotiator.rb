class Saasy::BillingLinkNegotiator
  attr_reader :subscription

  def initialize(user)
    @subscription = user.company.subscriptions.active.first
  end

  def link
    if render_form?
      "javascript:$('#external_billing_system').submit()"
    else
      Rails.application.routes.url_helpers.saasy_subscription_path(subscription.reference)
    end
  end

  def render_form?
    !subscription
  end
end
