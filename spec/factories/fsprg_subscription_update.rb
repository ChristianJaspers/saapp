FactoryGirl.define do
  factory :fsprg_subscription_update, class: FsprgSubscriptionUpdate do
    reference '12345'
    quantity '3'

    initialize_with { new(reference) }
  end
end
