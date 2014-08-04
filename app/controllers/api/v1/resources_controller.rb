class Api::V1::ResourcesController < Api::RestrictedApplicationController
  def index
    render_json(current_user.team, 200, serializer: Api::TeamSerializer)
  end
end
