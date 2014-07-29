# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :argument do
    sequence(:feature) { |n| "Feature ##{n}" }
    sequence(:benefit) { |n| "Benefit ##{n}" }
    product_group
    owner_id { create(:manager).id }
  end
end
