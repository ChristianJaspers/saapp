class Api::V1::PasswordsController < Api::RestrictedApplicationController
  skip_before_action :restrict_access, only: [:create]

  def create
    if params[:email].present? && (user = User.where(email: params[:email]).first)
      user.send_reset_password_instructions
      render_json({}, 200)
    else
      render_fail_json(:account_not_exist)
    end
  end

  def update
    current_user.password = current_user.password_confirmation = params[:password]
    if params[:password].present? && current_user.save
      render_json(current_user, 200, serializer: Api::UserSerializer)
    else
      render_fail_json(:invalid_password)
    end
  end
end
