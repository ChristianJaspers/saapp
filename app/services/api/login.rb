class Api::Login
  attr_reader :params, :user, :api_token

  def initialize(params)
    @params = params
  end

  def perform
    @user = User.users.authenticate(params[:email], params[:password])
    create_api_token if user
    update_device_info! if api_token
    self
  end

  private

  def create_api_token
    @api_token = ApiToken.find_or_create_by(user: user)
  end

  def update_device_info!
    PushNotifications::DeviceTokenUpdater.new(user, params).perform if user
  end
end
