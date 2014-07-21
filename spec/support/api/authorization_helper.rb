module Api::AuthorizationHelper
  def api_authorize_with(access_token)
    request.headers['Authorization'] = "Token token=#{access_token}"
  end
end
