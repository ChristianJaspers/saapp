module Api
  class Authentication
    attr_reader :param_token, :error_key, :params

    delegate :user, to: :api_token, allow_nil: true

    def initialize(params, param_token)
      @params = params
      @param_token = param_token
      @error_key = :forbidden
    end

    def authenticate!
      update_device_info!
      !!user
    end

    private

    def api_token
      @api_token ||= begin
        token = ApiToken.for_access_token(param_token).includes(:user).first
        if token_valid?(token, param_token) && can_use_system?(token)
          @error_key = nil
          token
        else
          nil
        end
      end
    end

    def token_valid?(token, param_token)
      token && Devise.secure_compare(token.access_token, param_token)
    end

    def can_use_system?(token)
      can = CompanySubscription.new(token.user).can_use_system?
      @error_key = :forbidden_no_subscription if !can
      can
    end

    def update_device_info!
      PushNotifications::DeviceTokenUpdater.new(user, params).perform if user
    end
  end
end
