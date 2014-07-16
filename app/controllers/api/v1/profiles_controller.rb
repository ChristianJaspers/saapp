class Api::V1::ProfilesController < Api::V1::RestrictedApiController
  def show
    render json: {
      user: {
        id: current_user.id,
        display_name: current_user.display_name,
        email: current_user.email,
        avatar_url: nil,
        avatar_thumb_url: nil
      }
    }
  end

  def avatar

  end
end
