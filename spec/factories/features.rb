# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feature do
    sequence(:description) { |n| "Feature ##{n}" }
    category_id { create(:category).id }
    owner_id { create(:manager).id }
  end
end
