class Manager::ManagerController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_manager!

  layout 'manager'

  private

  def authorize_manager!
    authorization_checks.each do |notice, check|
      unless check.call
        redirect_to root_path, notice: notice
        break
      end
    end
  end

  def authorization_checks
    [
      [t('common.unauthorized'), -> { current_user.manager? }],
      [t('subscriptions.subscription_expired_or_invalid'), -> { company_subscription.can_use_system? }]
    ]
  end
end
