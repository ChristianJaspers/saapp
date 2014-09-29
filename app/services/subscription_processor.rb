class SubscriptionProcessor < BusinessProcess::Base
  needs :params

  def call
    init_saasy_api and
      find_local_company_by_referrer and
      find_remote_subscription and
      update_or_create_local_subscription and
      update_company_lifetime_from_subscription
  end

  private

  attr_reader :api, :remote_subscription, :subscription, :company, :referrer

  def init_saasy_api
    @api = Saasy::Api.new
  end

  def find_local_company_by_referrer
    @referrer = User.find_by_id(params[:SubscriptionReferrer])
    @company = referrer ? Company.unscoped.find_by_id(referrer.team.company_id) : nil
  end

  def find_remote_subscription
    @remote_subscription = api.subscription.find(params[:SubscriptionReference])
  rescue FsprgException # reference not found
    nil
  end

  def update_or_create_local_subscription
    @subscription = Subscription.find_by(
      company_id: company.id,
      reference: remote_subscription.reference
    ) || Subscription.new

    subscription.company   = company
    subscription.referrer  = referrer
    subscription.reference = remote_subscription.reference
    subscription.quantity  = remote_subscription.quantity.to_i
    subscription.status    = remote_subscription.status
    subscription.ends_at   = remote_subscription.end_date
    subscription.is_test   = remote_subscription.test
    subscription.save
  end

  def update_company_lifetime_from_subscription
    # first we take active remote subscription - it will give the best subscription (the latest ends_at or even nil)
    # if not found take subscription that was created or updated moment ago
    better_subscription = (CompanySubscription.new(referrer).active_remote_subscription || subscription)
    if better_subscription.ends_at.present?
      company.remove_at!(better_subscription.ends_at + company.lifetime_before_is_removed)
    else
      company.do_not_remove!
    end
  end
end
