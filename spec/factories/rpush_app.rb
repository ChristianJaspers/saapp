FactoryGirl.define do
  factory :rpush_app, class: Rpush::Apns::App do
    name 'ios'
    certificate { File.read(Rails.root.join('config', 'certs', "sandbox.pem").to_s) }
    environment 'sandbox'
    password { ENV['APPLE_CERT_PASSWORD'] }
    connections 1
  end
end
