require 'rails_helper'

describe Admin::SubscriptionUpdater do
  subject { described_class.new(subscription, params) }
  before { travel_to(Time.parse("2014-09-01 12:00 UTC")) }
  after { travel_back }

  describe '#save' do
    let(:perform) { subject.save }

    context 'is trial subscription' do
      let(:subscription) { create(:subscription, :trial, ends_at: Time.now + 30.days) }
      let(:params) do
        {
          subscription: {
            "ends_at(1i)" => "2014",
            "ends_at(2i)" => "11",
            "ends_at(3i)" => "1",
            "ends_at(4i)" => "12",
            "ends_at(5i)" => "00"
          }.with_indifferent_access
        }.with_indifferent_access
      end

      it { expect(perform).to be_truthy }
      it { expect { perform }.to change { subscription.reload.ends_at }.from(Time.parse("2014-10-01 12:00 UTC")).to(Time.parse("2014-11-01 12:00 UTC")) }
      it { expect { perform }.to change { subscription.reload.send_reminder_at }.from(Time.parse("2014-09-24 12:00 UTC")).to(Time.parse("2014-10-25 12:00 UTC")) }
    end

    context 'is not trial subscription' do
      let(:subscription) { create(:subscription) }
      let(:params) { {subscription: {}}.with_indifferent_access }

      it { expect(perform).to be_falsey }
      it { expect { perform }.to_not change { subscription.reload.ends_at } }
      it { expect { perform }.to_not change { subscription.reload.send_reminder_at } }
    end
  end
end
