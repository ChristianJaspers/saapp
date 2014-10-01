required_env = [
  'MANDRILL_APIKEY',
  'MANDRILL_USERNAME'
]

if Rails.env.production?
  required_env += [
    'S3_BUCKET_NAME',
    'AWS_ACCESS_KEY_ID',
    'AWS_SECRET_ACCESS_KEY',
    'HOST',
    'NOREPLY_EMAIL',
    'SAASY_NOTIFICATION_KEY',
    'SAASY_API_USER',
    'SAASY_API_PASSWORD',
    'ENABLE_SAASY_PRODUCTION_MODE',
    'APPLE_PUSH_ENV',
    'APPLE_CERT_PASSWORD'
  ]
end

Figaro.require(*required_env)
