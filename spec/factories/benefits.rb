# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :benefit do
    sequence(:description) { |n| "Benefit ##{n}" }
    feature_id { create(:feature).id }
  end
end
