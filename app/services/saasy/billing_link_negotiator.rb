class Saasy::BillingLinkNegotiator
  def initialize(company_subscription)
    @company_subscription = company_subscription
  end

  def link
    if render_form?
      submit_form_link
    else
      saasy_subscription_link
    end
  end

  def render_form?
    company_subscription.needs_to_buy_subscription?
  end

private

  attr_reader :company_subscription

  def submit_form_link
    "javascript:$('#external_billing_system').submit()"
  end

  def saasy_subscription_link
    Rails.application.routes.url_helpers.saasy_subscription_path(company_subscription.active_remote_subscription.reference)
  end
end
