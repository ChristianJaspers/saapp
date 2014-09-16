require 'rails_helper'

describe Subscription do
  let(:now) { Time.new(2014, 7, 30, 12, 0, 0, "+00:00") }
  before { travel_to(now) }
  after { travel_back }

  describe '.start_trial_for_manager' do
    let(:manager) { create(:manager) }
    let(:perform) { described_class.start_trial_for_manager(manager) }

    it { expect { perform }.to change { Subscription.count }.by(1) }
    it { expect(perform).to be_truthy }

    context 'after creating trial' do
      let(:subscription) { Subscription.last }

      context 'no sales reps in company' do
        before { perform }

        it { expect(subscription.company_id).to eq manager.company.id }
        it { expect(subscription.reference).to eq 'trial' }
        it { expect(subscription.referrer_id).to eq manager.id }
        it { expect(subscription.quantity).to eq 0 }
        it { expect(subscription.status).to eq 'active' }
        it { expect(subscription.ends_at).to eq(now + 30.days) }
        it { expect(subscription.send_reminder_at).to eq(now + 30.days - 7.days) }
      end

      context 'two sales reps in company' do
        before do
          2.times { create(:user, team: manager.team) }
          perform
        end

        it { expect(subscription.quantity).to eq 2 }
      end
    end
  end

  describe '.detect_active_subscription_for_user' do
    let(:user) { create(:manager) }
    let(:perform) { described_class.detect_active_subscription_for_user(user) }

    pending
  end

  describe '.active_remote' do
    let(:perform) { described_class.active_remote.pluck(:id) }

    before do
      allow(Subscription).to receive(:remote_subscriptions).and_call_original
      allow(Subscription).to receive(:active).and_call_original
      perform
    end

    it { expect(Subscription).to have_received(:remote_subscriptions) }
    it { expect(Subscription).to have_received(:active) }
  end

  describe '.active' do
    let!(:subscription_1) { create(:subscription, ends_at: nil) }
    let!(:subscription_2) { create(:subscription, ends_at: now + 1.hour) }
    let(:perform) { described_class.active.pluck(:id) }

    before do
      create(:subscription, ends_at: nil, status: 'whatever')
      create(:subscription, ends_at: now - 1.hour)
    end

    it { expect(perform).to match_array [subscription_1.id, subscription_2.id] }
  end

  describe '.trials' do
    let!(:subscription_1) { create(:subscription, reference: 'trial') }
    let(:perform) { described_class.trials.pluck(:id) }

    before do
      create(:subscription, reference: 'abc')
      create(:subscription, reference: '123')
    end

    it { expect(perform).to eq [subscription_1.id] }
  end

  describe '.remote_subscriptions' do
    let!(:subscription_1) { create(:subscription, reference: 'whatever') }
    let(:perform) { described_class.remote_subscriptions.pluck(:id) }

    before do
      create(:subscription, reference: 'trial')
    end

    it { expect(perform).to eq [subscription_1.id] }
  end

  describe '.deos_not_end_yet' do
    let!(:subscription_1) { create(:subscription, ends_at: nil) }
    let!(:subscription_2) { create(:subscription, ends_at: now + 1.hour) }
    let(:perform) { described_class.deos_not_end_yet.pluck(:id) }

    before do
      create(:subscription, ends_at: now - 1.hour)

    end

    it { expect(perform).to match_array [subscription_1.id, subscription_2.id] }
  end

  describe '.non_empty_end_date' do
    let!(:subscription_1) { create(:subscription, ends_at: now) }
    let(:perform) { described_class.non_empty_end_date.pluck(:id) }

    before do
      create(:subscription, ends_at: nil)
    end

    it { expect(perform).to eq [subscription_1.id] }
  end

  describe '#save' do
    let(:perform) { subscription.save }

    context 'subscription is already created' do
      let(:subscription) { create(:subscription) }
      before { subscription.ends_at = now }

      context 'after save' do
        it { expect { perform }.not_to change { subscription.reload.send_reminder_at } }
      end
    end

    context 'subscription does not exist yet' do
      let(:reminder_expected_at) { now - 7.days }
      let(:subscription) { build(:subscription) }
      before { subscription.ends_at = now }

      context 'after save' do
        before { perform }
        it { expect(subscription.reload.send_reminder_at).to eq reminder_expected_at }
      end
    end
  end

  describe '#trial?' do
    let(:perform) { create(:subscription, reference: 'trial').trial? }

    it { expect(perform).to be_truthy }
  end

  describe '#active?' do
    let(:perform) { subscription.active? }

    context 'status is active' do
      let(:subscription) { create(:subscription, status: 'active') }

      it { expect(perform).to be_truthy }
    end

    context 'status is different to active' do
      let(:subscription) { create(:subscription, status: 'whatever') }

      it { expect(perform).to be_falsey }
    end

    context 'end date is before current time' do
      let(:subscription) { create(:subscription, ends_at: Time.now - 1.hour) }

      it { expect(perform).to be_falsey }
    end

    context 'end date is after current time' do
      let(:subscription) { create(:subscription, ends_at: Time.now + 1.hour) }

      it { expect(perform).to be_truthy }
    end
  end

  describe '#ends_within_week?' do
    let(:subscription) { create(:subscription, ends_at: ends_at) }
    let(:perform) { subscription.ends_within_week? }

    context 'ends at is nil' do
      let(:ends_at) { nil }
      it { expect(perform).to be_falsey }
    end

    context 'ends at is set 8 days after current time' do
      let(:ends_at) { now + 8.days }
      it { expect(perform).to be_falsey }
    end

    context 'ends at is set 7 days after current time' do
      let(:ends_at) { now + 7.days }
      it { expect(perform).to be_truthy }
    end

    context 'ends at is set 2 days after current time' do
      let(:ends_at) { now + 2.days }
      it { expect(perform).to be_truthy }
    end

    context 'ends at is set 1 hour before current time' do
      let(:ends_at) { now - 1.hour }
      it { expect(perform).to be_falsey }
    end
  end
end
