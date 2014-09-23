class Api::RestrictedApplicationController < Api::ApplicationController
  before_action :restrict_access
  expose(:current_user) { @api_authentication.try :user }

  private

  def restrict_access
    result = authenticate_with_http_token do |token, options|
      @api_authentication = Api::Authentication.new(token)
      @api_authentication.authenticate!
    end
    render_fail_json(authentication_error_key) unless result
  end

  def authentication_error_key
    if @api_authentication
      @api_authentication.error_key
    else
      :forbidden
    end
  end
end
