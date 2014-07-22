# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "Category ##{n}" }
    owner_id { create(:manager).id }

    trait :archived do
      archived_at { Time.now - 1.day }
    end
  end
end
