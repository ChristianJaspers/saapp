class Manager::DestroyUser < BusinessProcess::Base
  needs :user

  def call
    destroy_user and
      update_remote_subscription
  end

  private

  def destroy_user
    user.remove!
  end

  def update_remote_subscription
    SubscriptionUpdater.call(user: user).success?
  end
end
