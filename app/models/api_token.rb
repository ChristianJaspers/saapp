class ApiToken < ActiveRecord::Base
  TOKEN_LENGTH = 40

  belongs_to :user, inverse_of: :api_token

  before_create :generate_access_token

  validates :access_token, uniqueness: true
  validates :user_id, presence: true

  scope :for_access_token, ->(access_token) { where(access_token: access_token.to_s) }
  scope :includes_user, -> { includes(:user) }

  # def device_info=(params)
  #   self.notification_token = params[:notification_token]
  #   self.platform = params[:platform]
  #   self.locale = params[:locale]
  # end

  # def device_info
  #   {
  #     notification_token: notification_token,
  #     platform: platform,
  #     locale: locale
  #   }
  # end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.urlsafe_base64(TOKEN_LENGTH)
    end while self.class.exists?(access_token: access_token)
  end
end
