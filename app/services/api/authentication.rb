module Api
  class Authentication
    attr_reader :param_token
    delegate :user, to: :api_token, allow_nil: true

    def initialize(param_token)
      @param_token = param_token
    end

    def authenticate!
      !!user
    end

    private

    def api_token
      @api_token ||= begin
        token = ApiToken.for_access_token(param_token).includes(:user).first
        if token_valid?(token, param_token) && can_use_system?(token)
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
      CompanySubscription.new(token.user).can_use_system?
    end
  end
end
