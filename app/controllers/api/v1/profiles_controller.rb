class Api::V1::ProfilesController < Api::RestrictedApplicationController
  def show
    render_json(current_user, 200)
  end
end
