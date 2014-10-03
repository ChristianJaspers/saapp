FactoryGirl.define do
  factory :api_token do
    user
    notification_token '123'
    platform 'ios'
  end
end
