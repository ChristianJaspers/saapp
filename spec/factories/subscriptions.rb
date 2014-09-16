# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    company
    referrer { create(:manager) }
    reference '123'
    quantity 0
    status 'active'
  end
end
