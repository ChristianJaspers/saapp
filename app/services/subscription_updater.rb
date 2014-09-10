class SubscriptionUpdater < BusinessProcess::Base
  needs :company

  def call
    find_subscription and
      init_saasy_api and
      get_new_quantity and
      update_remote_subscription
  end

  private

  attr_reader :api, :quantity

  def find_subscription
    company.subscriptions.active.first # for now
  end

  def init_saasy_api
    @api = Saasy::Api.new
  end

  def get_new_quantity
    @quantity = company.sales_reps_count
  end

  def update_remote_subscription
    api.subscription.update_quantity(quantity)
  end
end
