class Api::Authentication
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
    unless @api_token
      token = ApiToken.for_access_token(param_token).includes_user.first
      @api_token = token if token && Devise.secure_compare(token.access_token, param_token)
    end
    @api_token
  end
end
