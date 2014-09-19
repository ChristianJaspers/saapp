require 'rails_helper'

describe SubscriptionUpdater do
  describe '.call' do
    let(:parameter_object) { double(user: manager) }
    let(:perform) { described_class.call(parameter_object) }
    let(:manager) { create(:user, :manager) }
    let!(:subscription) { create(:subscription, company: manager.company) }
    let(:sales_reps_count) { 2 }

    before do
      create_list(:user, sales_reps_count, team: manager.team)
      allow_any_instance_of(Saasy::ApiModules::Subscription).to receive(:update_quantity).and_return(nil)
    end

    context 'valid active remote subscription' do
      it do
        expect_any_instance_of(Saasy::ApiModules::Subscription).to receive(:update_quantity).with(subscription.reference, sales_reps_count)
        perform
      end
    end

  end
end
