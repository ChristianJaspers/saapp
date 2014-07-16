class Api::V1::AuthController < Api::BaseApplicationApiController
  def login
    api_login = Api::Login.new(params).perform
    if api_login.user
      render_json(
        {
          user: {
            id: api_login.user.id,
            display_name: api_login.user.display_name,
            email: api_login.user.email,
            avatar_url: nil,
            avatar_thumb_url: nil
          },
          access_token: api_login.user.access_token
        },
        200
      )
    else
      render_fail_json(:not_authenticated)
    end
  end

  def forgot_password
  end

end
