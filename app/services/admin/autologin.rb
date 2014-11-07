class Admin::Autologin
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def perform
    autologin = ::Autologin.generate_for_user(user)
    autologin.token if autologin
  end
end
