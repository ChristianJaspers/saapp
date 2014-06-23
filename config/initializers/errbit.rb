Airbrake.configure do |config|
  config.api_key = '57ef6649381ed0d8e7a990aa904977ad'
  config.host    = 'errbit.selleo.com'
  config.port    = 443
  config.secure  = config.port == 443
end
