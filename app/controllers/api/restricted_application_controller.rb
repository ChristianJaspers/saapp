class Api::RestrictedApplicationController < Api::ApplicationController
  before_action :restrict_access

  helper_method :current_user

private

  def current_user
    @api_authentication.try :user
  end

  def restrict_access
    result = authenticate_with_http_token do |token, options|
      @api_authentication = Api::Authentication.new(token)
      @api_authentication.authenticate!
    end
    render_fail_json(:forbidden) unless result
  end
end
