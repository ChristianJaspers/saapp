class Api::Login
  attr_reader :params, :user

  def initialize(params)
    @params = params
  end

  def perform
    @user = User.authenticate(params[:email], params[:password])
    if user
      ApiToken.create_with(
        user: user
      ).find_or_create_by(user: user)
    end
    self
  end
end
