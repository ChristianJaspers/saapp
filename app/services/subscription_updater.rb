class SubscriptionUpdater < BusinessProcess::Base
  needs :user

  def call
    find_subscription and
      init_saasy_api and
      get_new_quantity and
      update_remote_subscription
  end

  private

  attr_reader :api, :quantity, :subscription

  def find_subscription
    @subscription = CompanySubscription.new(user).active_remote_subscription
  end

  def init_saasy_api
    @api = Saasy::Api.new
  end

  def get_new_quantity
    @quantity = company.sales_reps_count
  end

  def update_remote_subscription
    api.subscription.update_quantity(subscription.reference, quantity)
    quantity
  end
end
