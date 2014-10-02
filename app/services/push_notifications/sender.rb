class PushNotifications::Sender
  attr_reader :user, :notifcation, :api_token

  def initialize(user)
    @user = user
  end

  def send
    @api_token = user.api_token
    if api_token && user_device_token.present?
      prepare_notifcation
      notifcation.save!
    end
  end

  private

  def prepare_notifcation
    @notifcation = notification_class.new
    notifcation.app = app
    set_token
    set_payload
    notifcation
  end

  def notification_class
    Rpush::Apns::Notification # OR in future: Rpush::Gcm::Notification
  end

  def app
    @app ||= Rpush::Apns::App.find_by_name("ios") # OR in future Rpush::Gcm::App.find_by_name("android")
  end

  def set_token
    notifcation.device_token = user_device_token # OR in future notifcation.registration_ids = ['token', ...]
  end

  def set_payload
    notifcation.badge = unrated_arguments_count
  end

  def unrated_arguments_count
    2
  end

  def user_device_token
    api_token.notifcation_token
  end

end
