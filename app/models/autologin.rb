class Autologin < ActiveRecord::Base
  EXPIRATION_DURATION = 30.minutes

  belongs_to :user

  validates :user, presence: true
  validates :token, presence: true, uniqueness: true

  def self.generate_for_user(user)
    autologin = ::Autologin.new(user: user)
    autologin.token = SecureRandom.urlsafe_base64(64)
    autologin.expires_at = Time.now + EXPIRATION_DURATION
    autologin.save ? autologin : nil
  end

  def self.authenticate_user(token)
    autologin = ::Autologin.
      includes(:user).
      where(token: token).
      where('expires_at >= ?', Time.now).first

    autologin ? autologin.user : nil
  end
end
