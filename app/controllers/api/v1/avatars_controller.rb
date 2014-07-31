class Api::V1::AvatarsController < Api::RestrictedApplicationController
  def update
    current_user.avatar = params[:file]
    if params[:file].present? && current_user.save
      render_json(current_user, 200, serializer: Api::UserSerializer)
    else
      render_fail_json(:invalid_file_upload)
    end
  end
end
