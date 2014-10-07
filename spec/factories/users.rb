FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user#{i + 1}@example.com" }
    password '12345678'
    password_confirmation { password }
    team
    role 'user'
    confirmed_at { Time.now }

    trait :admin do
      role 'admin'
    end

    trait :manager do
      role 'manager'
    end

    trait :cms_editor do
      role 'cms_editor'
    end

    trait :unconfirmed_user do
      password nil
      password_confirmation nil
      confirmed_at nil
    end

    factory :manager do
      role 'manager'
    end
  end
end
