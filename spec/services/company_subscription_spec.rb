require 'rails_helper'

describe CompanySubscription do
  before { travel_to(Time.new(2014, 7, 30, 12, 0, 0, "+00:00")) }
  after { travel_back }
  subject { described_class.new(user) }
  let(:user) { create(:manager) }

  describe '#can_use_system?' do
    let(:perform) { subject.can_use_system? }
    let(:subscription) { create(:subscription, company: user.company, referrer: user) }

    context 'active subscription exist' do
      before { allow(subject).to receive(:active_subscription).and_return(subscription) }

      it { expect(perform).to eq true }
    end

    context 'active subscription does not exist' do
      before { allow(subject).to receive(:active_subscription).and_return(nil) }

      it { expect(perform).to eq false }
    end
  end

  describe '#needs_to_buy_subscription?' do
    let(:perform) { subject.needs_to_buy_subscription? }
    let(:subscription) { create(:subscription, company: user.company, referrer: user) }

    context 'active remote subscription exist' do
      before { allow(subject).to receive(:active_remote_subscription).and_return(subscription) }

      it { expect(perform).to eq false }
    end

    context 'active remote subscription does not exist' do
      before { allow(subject).to receive(:active_remote_subscription).and_return(nil) }

      it { expect(perform).to eq true }
    end
  end

  describe '#display_reminder?' do
    let(:perform) { subject.display_reminder? }
    let(:subscription) { create(:subscription, company: user.company, referrer: user) }

    context 'no subscription' do
      before { allow(subject).to receive(:active_subscription).and_return(nil) }

      it { expect(perform).to be_falsey }
    end

    context 'subscription exists' do
      before { allow(subject).to receive(:active_subscription).and_return(subscription) }

      context 'subscription but no trial' do
        before { allow(subscription).to receive(:trial?).and_return(false) }

        it { expect(perform).to be_falsey }
      end

      context 'trail subscription but ends later' do
        before do
          allow(subscription).to receive(:trial?).and_return(false)
          allow(subscription).to receive(:ends_within_week?).and_return(false)
        end

        it { expect(perform).to be_falsey }
      end

      context 'valid subscription' do
        before do
          allow(subscription).to receive(:trial?).and_return(true)
          allow(subscription).to receive(:ends_within_week?).and_return(true)
        end

        it { expect(perform).to be_truthy }
      end
    end
  end

  describe '#link_negotiator' do
    let(:perform) { subject.link_negotiator }

    it 'returns instance of link negotiator' do
      expect(perform).to be_kind_of(Saasy::BillingLinkNegotiator)
    end
  end

  describe '#billing_form' do
    let(:perform) { subject.billing_form }

    it 'returns instance of billing form' do
      expect(perform).to be_kind_of(Saasy::BillingForm)
    end
  end

  describe '#active_subscription' do
    let(:perform) { subject.active_subscription }

    context 'trail has no end date' do
      before { create(:subscription, :trial, ends_at: nil, company: user.company) }
      it { expect(perform).to_not be_nil }
    end

    context 'trail has end date in the future' do
      before { create(:subscription, :trial, ends_at: Time.now + 1.hour, company: user.company) }
      it { expect(perform).to_not be_nil }
    end

    context 'trail has end data in the past' do
      before { create(:subscription, :trial, ends_at: Time.now - 1.hour, company: user.company) }
      it { expect(perform).to be_nil }
    end

    context 'remote subscription has no end date' do
      before { create(:subscription, ends_at: nil, company: user.company) }
      it { expect(perform).to_not be_nil }
    end

    context 'remote subscription has end date in the future' do
      before { create(:subscription, ends_at: Time.now + 1.hour, company: user.company) }
      it { expect(perform).to_not be_nil }
    end

    context 'remote subscription has end date in the past' do
      before { create(:subscription, ends_at: Time.now - 1.hour, company: user.company) }
      it { expect(perform).to be_nil }
    end

    context 'trail has active status' do
      before { create(:subscription, :trial, company: user.company) }
      it { expect(perform).to_not be_nil }
    end

    context 'trial has no active status' do
      before { create(:subscription, :trial, status: 'other', company: user.company) }
      it { expect(perform).to be_nil }
    end

    context 'remote subscription has active status' do
      before { create(:subscription, company: user.company) }
      it { expect(perform).to_not be_nil }
    end

    context 'remote subscription has no active status' do
      before { create(:subscription, status: 'other', company: user.company) }
      it { expect(perform).to be_nil }
    end

    context 'there are more active subscriptions' do
      context 'one with no end date' do
        let!(:subscription_1) { create(:subscription, company: user.company, ends_at: nil) }
        let!(:subscription_2) { create(:subscription, company: user.company, ends_at: Time.now + 1.days) }

        it { expect(perform.id).to eq subscription_1.id }
      end

      context 'different end dates' do
        let!(:subscription_1) { create(:subscription, company: user.company, ends_at: Time.now + 5.days) }
        let!(:subscription_2) { create(:subscription, company: user.company, ends_at: Time.now + 1.days) }

        it { expect(perform.id).to eq subscription_1.id }
      end

      context 'the same end date' do
        let!(:subscription_1) { create(:subscription, company: user.company) }
        let!(:subscription_2) { create(:subscription, company: user.company) }

        it { expect(perform.id).to eq [subscription_1.id, subscription_2.id].max }
      end
    end
  end

  describe '#active_remote_subscription' do
    let(:perform) { subject.active_remote_subscription }

    context 'trail has no end date' do
      before { create(:subscription, :trial, ends_at: nil, company: user.company) }
      it { expect(perform).to be_nil }
    end

    context 'trail has end date in the future' do
      before { create(:subscription, :trial, ends_at: Time.now + 1.hour, company: user.company) }
      it { expect(perform).to be_nil }
    end

    context 'trail has end data in the past' do
      before { create(:subscription, :trial, ends_at: Time.now - 1.hour, company: user.company) }
      it { expect(perform).to be_nil }
    end

    context 'remote subscription has no end date' do
      before { create(:subscription, ends_at: nil, company: user.company) }
      it { expect(perform).to_not be_nil }
    end

    context 'remote subscription has end date in the future' do
      before { create(:subscription, ends_at: Time.now + 1.hour, company: user.company) }
      it { expect(perform).to_not be_nil }
    end

    context 'remote subscription has end date in the past' do
      before { create(:subscription, ends_at: Time.now - 1.hour, company: user.company) }
      it { expect(perform).to be_nil }
    end

    context 'trail has active status' do
      before { create(:subscription, :trial, company: user.company) }
      it { expect(perform).to be_nil }
    end

    context 'trial has no active status' do
      before { create(:subscription, :trial, status: 'other', company: user.company) }
      it { expect(perform).to be_nil }
    end

    context 'remote subscription has active status' do
      before { create(:subscription, company: user.company) }
      it { expect(perform).to_not be_nil }
    end

    context 'remote subscription has no active status' do
      before { create(:subscription, status: 'other', company: user.company) }
      it { expect(perform).to be_nil }
    end

    context 'there are more active subscriptions' do
      context 'one with no end date' do
        let!(:subscription_1) { create(:subscription, company: user.company, ends_at: nil) }
        let!(:subscription_2) { create(:subscription, company: user.company, ends_at: Time.now + 1.days) }

        it { expect(perform.id).to eq subscription_1.id }
      end

      context 'different end dates' do
        let!(:subscription_1) { create(:subscription, company: user.company, ends_at: Time.now + 5.days) }
        let!(:subscription_2) { create(:subscription, company: user.company, ends_at: Time.now + 1.days) }

        it { expect(perform.id).to eq subscription_1.id }
      end

      context 'the same end date' do
        let!(:subscription_1) { create(:subscription, company: user.company) }
        let!(:subscription_2) { create(:subscription, company: user.company) }

        it { expect(perform.id).to eq [subscription_1.id, subscription_2.id].max }
      end
    end
  end
end
