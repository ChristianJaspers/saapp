class PushNotifications::Sender
  attr_reader :users_with_unrated_arguments, :user_ids, :api_tokens

  def initialize(users_with_unrated_arguments = {})
    @users_with_unrated_arguments = users_with_unrated_arguments
    @user_ids = users_with_unrated_arguments.keys
  end

  def send
    @api_tokens = ApiToken.with_notification_token.where(user_id: user_ids)
    queue_notifcations if api_tokens.present?
  end

  private

  def queue_notifcations
    api_tokens.each do |api_token|
      notification = build_notification(api_token)
      notification.save!
    end
  end

  def build_notification(api_token)
    notification = notification_class.new
    notification.app = app
    set_token(notification, api_token)
    set_payload(notification, api_token)
    notification
  end

  def notification_class
    Rpush::Apns::Notification # OR in future: Rpush::Gcm::Notification
  end

  def app
    @app ||= Rpush::Apns::App.find_by_name("ios") # OR in future Rpush::Gcm::App.find_by_name("android")
  end

  def set_token(notification, api_token)
    notification.device_token = api_token.notification_token # OR in future notification.registration_ids = ['token', ...]
  end

  def set_payload(notification, api_token)
    notification.badge = users_with_unrated_arguments[api_token.user_id]
  end
end
