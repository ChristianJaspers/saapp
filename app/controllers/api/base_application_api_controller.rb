class Api::BaseApplicationApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  respond_to :json

private

  def render_json(json, status)
    render json: json, status: status
  end

  def render_fail_json(error_kind)
    http_status, internal_status, error_message = error_data(error_kind)
    render_json(
      {
        error: {
          code: internal_status,
          message: error_message
        }
      },
      http_status
    )
  end

  def error_data(error_kind)
    case error_kind
    when :not_authenticated
      [401, 1003, 'Can not login']
    when :forbidden
      [403, 1010, 'You don\'t have access']
    else
      raise "Wrong error kind: #{error_kind}"
    end
  end
end
