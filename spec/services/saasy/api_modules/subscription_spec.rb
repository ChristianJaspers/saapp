require 'rails_helper'

describe Saasy::ApiModules::Subscription do
  let(:fast_spring) { FastSpring.new('1', '2', '3') }
  let(:fsprg_subscription) { build(:fsprg_subscription, reference: 'qwerty') }
  let(:reference_number) { fsprg_subscription.reference }
  subject { described_class.new(fast_spring) }

  before do
    allow(fsprg_subscription).to receive(:customer_url).and_return('http://customer_url')
    allow(fast_spring).to receive(:get_subscription).and_return(fsprg_subscription)
    allow(fast_spring).to receive(:update_subscription)
  end

  describe '#find' do
    let(:perform) { subject.find(reference_number) }

    it { expect(perform).to eq fsprg_subscription }
  end

  describe '#update_quantity' do
    let(:fsprg_subscription_update) { build(:fsprg_subscription_update, reference: reference_number) }
    let(:quantity) { 10 }
    let(:perform) { subject.update_quantity(reference_number, quantity) }

    context 'after perform' do
      before do
        allow(FsprgSubscriptionUpdate).to receive(:new).with(reference_number).and_return(fsprg_subscription_update)
        allow(fsprg_subscription_update).to receive(:quantity=).and_call_original
        perform
      end

      it { expect(fast_spring).to have_received(:update_subscription).with(fsprg_subscription_update) }
      it { expect(fsprg_subscription_update).to have_received(:quantity=).with('10') }
      it { expect(fsprg_subscription_update.reference).to eq reference_number }
    end
  end

  describe '#management_url' do
    let(:perform) { subject.management_url(reference_number) }

    it { expect(perform).to eq 'http://customer_url' }
  end
end
