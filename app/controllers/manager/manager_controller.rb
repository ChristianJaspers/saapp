class Manager::ManagerController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_manager!
  before_action :set_warning_about_possible_subscription_expiration

  layout 'manager'

  private

  def authorize_manager!
    authorization_checks.each do |notice, check|
      unless check.call
        redirect_to root_path, alert: notice
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

  def set_warning_about_possible_subscription_expiration
    flash[:warning] = I18n.t('subscriptions.trial_subscription_will_expire_within_week') if company_subscription.display_reminder?
  end
end
