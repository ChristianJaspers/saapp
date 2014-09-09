class Saasy::Api
  attr_reader :subscription

  def initialize
    @fastspring = FastSpring.new('copenhagenapphouse', ENV['SAASY_API_USER'], ENV['SAASY_API_PASSWORD'])
    @fastspring.test_mode = true
    @subscription = Saasy::ApiModules::Subscription.new(fastspring)
  end

  def self.authenticate_callback?(security_data, security_hash)
    Digest::MD5.hexdigest("#{ security_data }#{ ENV['SAASY_NOTIFICATION_KEY'] }") == security_hash
  end

  private

  attr_reader :fastspring
end
