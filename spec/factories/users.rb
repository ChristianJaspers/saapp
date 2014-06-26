FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user#{i + 1}@example.com" }
    password '12345678'
    password_confirmation { password }
    role 'user'

    trait :admin do
      role 'admin'
    end

    trait :manager do
      role 'manager'
    end
end
