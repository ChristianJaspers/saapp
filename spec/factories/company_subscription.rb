FactoryGirl.define do
  factory :company_subscription, class: CompanySubscription do
    initialize_with { new(create(:manager)) }
  end
end
