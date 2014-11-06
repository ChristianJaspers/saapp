class Admin::SubscriptionUpdater
  attr_reader :subscription, :params

  def initialize(subscription, params)
    @subscription = subscription
    @params = params
  end

  def save
    if subscription.trial?
      subscription.attributes = {
        "ends_at(1i)" => params[:subscription]['ends_at(1i)'],
        "ends_at(2i)" => params[:subscription]['ends_at(2i)'],
        "ends_at(3i)" => params[:subscription]['ends_at(3i)'],
        "ends_at(4i)" => params[:subscription]['ends_at(4i)'],
        "ends_at(5i)" => params[:subscription]['ends_at(5i)']
      }
      subscription.send_reminder_at = subscription.ends_at - Subscription::ENDS_WITHIN_WEEK_DURATION
      subscription.save
    else
      false
    end
  end
end
