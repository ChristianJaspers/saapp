class Api::UploadAvatarForUser < BusinessProcess::Base
  include BusinessProcess::Errorable

  needs :params
  needs :current_user

  def call
    validate_params and
      save_avatar
  end

  private

  def validate_params
    check_for_error :invalid_file_parameter do
      params[:file].present?
    end
  end

  def save_avatar
    current_user.avatar = params[:file]
    if current_user.save
      current_user
    else
      self.error = current_user.errors.has_key?(:avatar_file_size) ? :file_is_too_big : :invalid_file_type
      nil
    end
  end
end
