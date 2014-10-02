namespace :push_notifications do

  desc 'Init apps'
  task init_apps: :environment do
    unless Rpush::Apns::App.find_by_name('ios')
      ios_app = Rpush::Apns::App.new
      ios_app.name = "ios"
      ios_app.certificate = File.read Rails.root.join('config', 'certs', "#{ENV['APPLE_PUSH_ENV']}.pem").to_s
      ios_app.environment = ENV['APPLE_PUSH_ENV'] # APNs environment.
      ios_app.password = ENV['APPLE_CERT_PASSWORD']
      ios_app.connections = 1
      ios_app.save!
      puts "iOS app created"
    else
      puts "iOS app already exists"
    end
  end

  desc 'Send using rpush'
  task send: :environment do
    Rpush.push
    Rpush.apns_feedback
  end

end
