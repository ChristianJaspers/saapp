FactoryGirl.define do
  factory :fsprg_subscription, class: FsprgSubscription do
    reference '12345'
    quantity '3'
    status 'active'
    end_date nil

    trait :ends_in_1_day do
      end_date Time.now.to_date + 1.day
    end
  end
end

=begin

#<FsprgSubscription:0x0000000c9fb5f8
 @cancelable="true",
 @customer=
  #<FsprgCustomer:0x0000000c9fb058
   @company=nil,
   @email="user@example.com",
   @first_name="One",
   @last_name="Two",
   @phone_number=nil>,
 @customer_url="https://sites.fastspring.com/copenhagenapphouse/order/s/xxxxx",
 @next_period_date=Sat, 18 Oct 2014,
 @product_name="BetterSalesman",
 @quantity="8",
 @reference="COP140918-2835-36165S",
 @status="active",
 @status_changed=Thu, 18 Sep 2014,
 @status_reason=nil,
 @tags=nil,
 @test="true">

=end
