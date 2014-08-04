class Api::Login
  attr_reader :params, :user

  def initialize(params)
    @params = params
  end

  def perform
    @user = User.users.authenticate(params[:email], params[:password])
    ApiToken.find_or_create_by(user: user) if user
    self
  end
end
