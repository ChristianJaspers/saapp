class Api::V1::PasswordsController < Api::ApplicationController
  def create
    if params[:email].present? && (user = User.where(email: params[:email]).first)
      user.send_reset_password_instructions
      render_json({}, 200)
    else
      render_fail_json(:account_not_exist)
    end
  end
end
