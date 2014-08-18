class Api::ApplicationController < ::ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :autodetect_language
  skip_before_action :set_current_locale

  respond_to :json

private

  def render_json(data, status, meta = {})
    render meta.merge(status: status, json: data)
  end

  def render_fail_json(error_key)
    mapping = Api::ErrorMapping.new(error_key, current_user, params)
    render_json(mapping.to_hash, mapping.http_code)
  end
end
