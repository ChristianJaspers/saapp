class Api::V1::ProfilesController < Api::V1::RestrictedApiController
  def show
    render_json(user_json(current_user), 200)
  end

  def avatar
    current_user.avatar = params[:file]
    if params[:file].present? && current_user.save
      show
    else
      render_fail_json(:invalid_file_upload)
    end
  end
end
