class SubscriptionUpdater < BusinessProcess::Base
  needs :user

  def call
    find_subscription
    process_update
  end

  private

  attr_reader :api, :quantity, :subscription

  def process_update
    if subscription
      process_update_remote_subscription
    else
      true
    end
  end

  def process_update_remote_subscription
    init_saasy_api and
    get_new_quantity and
    update_remote_subscription
  end

  def find_subscription
    @subscription = CompanySubscription.new(user).active_remote_subscription
  end

  def init_saasy_api
    @api = Saasy::Api.new
  end

  def get_new_quantity
    @quantity = user.company.sales_reps_count
  end

  def update_remote_subscription
    begin
      api.subscription.update_quantity(subscription.reference, quantity)
      quantity
    rescue FsprgException => e
      Rails.logger.error "FsprgException: #{e.message}"
      nil
    end
  end
end
