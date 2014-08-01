puts ENV.inspect

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
    'NOREPLY_EMAIL'
  ]
end

Figaro.require(*required_env)
