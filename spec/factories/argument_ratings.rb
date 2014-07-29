# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :argument_rating do
    argument
    rater_id { create(:user).id }
    rating 1
  end
end
