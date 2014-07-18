class Api::V1::AuthController < Api::ApplicationController
  def create
    api_login = Api::Login.new(params).perform
    if api_login.user
      render_json(
        api_login.user,
        200,
        meta: api_login.user.access_token,
        meta_key: 'access_token'
      )
    else
      render_fail_json(:not_authenticated)
    end
  end

  def forgot_password
    if params[:email].present? && (user = User.where(email: params[:email]).first)
      user.send_reset_password_instructions
      render_json({}, 200)
    else
      render_fail_json(:account_not_exist)
    end
  end
end
