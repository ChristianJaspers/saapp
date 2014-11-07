# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :autologin do
    user
    sequence(:token) { |n| "token-#{n}" }
    expires_at { Time.now + 30.minutes }
  end
end
