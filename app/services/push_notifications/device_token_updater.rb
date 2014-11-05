class PushNotifications::DeviceTokenUpdater
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def perform
    if device_info.present?
      api_token = user.api_token
      user.update_column(:locale, locale)
      if api_token
        remove_duplicated_tokens(api_token, notification_token)
        api_token.update_columns(
          notification_token: notification_token,
          platform: platform
        )
      end
      api_token
    end
  end

  private

  def remove_duplicated_tokens(api_token, notification_token)
    ApiToken.where('id != ? AND notification_token = ?', api_token.id, notification_token).update_all(notification_token: nil)
  end

  def device_info
    @device_info ||= params.fetch(:device_info, {})
  end

  def notification_token
    device_info.fetch(:notification_token, nil)
  end

  def platform
    device_info.fetch(:platform, nil)
  end

  def locale
    device_info.fetch(:locale, I18n.default_locale)
  end
end
