# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gamification_scoring, class: Gamification::Scoring do
    amount 1
    beneficiary_id { create(:user).id }
    event_name 'some_event'
  end
end
