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

  describe '.to_be_sent_as_reminders' do
    let(:perform) { described_class.to_be_sent_as_reminders.pluck(:id) }
    let!(:subscription_1) { create(:subscription, reference: 'trial', send_reminder_at: now - 2.days) }
    let!(:subscription_2) { create(:subscription, reference: 'trial', send_reminder_at: now - 1.day) }
    let!(:subscription_3) { create(:subscription, reference: 'trial', send_reminder_at: now) }
    let!(:subscription_4) { create(:subscription, reference: 'trial', send_reminder_at: now + 1.day) }
    let!(:subscription_5) { create(:subscription, reference: '123', send_reminder_at: now - 2.days) }
    let!(:subscription_6) { create(:subscription, reference: '123', send_reminder_at: now - 1.day) }
    let!(:subscription_7) { create(:subscription, reference: '123', send_reminder_at: now) }
    let!(:subscription_8) { create(:subscription, reference: '123', send_reminder_at: now + 1.day) }

    it do
      expect(perform).to match_array [
        subscription_1.id,
        subscription_2.id,
        subscription_3.id
      ]
    end
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
      let(:subscription) { build(:subscription, :trial) }
      before { subscription.ends_at = now }

      context 'after save' do
        before { perform }
        it { expect(subscription.reload.send_reminder_at).to eq reminder_expected_at }
      end
    end
  end

  describe '#company' do
    let(:perform) { subscription.reload.company }
    let(:subscription) { create(:subscription) }

    context 'company is marked as removed' do
      before { Company.where(id: subscription.company_id).update_all(remove_at: Time.now) }
      it { expect(perform).to be_nil }
    end

    context 'company is not marked as removed' do
      it { expect(perform).to_not be_nil }
    end
  end

  describe '#company_with_deleted' do
    let(:perform) { subscription.company_with_deleted }
    let(:subscription) { create(:subscription) }

    context 'company is marked as removed' do
      before { Company.where(id: subscription.company_id).update_all(remove_at: Time.now) }
      it { expect(perform).to_not be_nil }
    end

    context 'company is not marked as removed' do
      it { expect(perform).to_not be_nil }
    end
  end

  describe '#expired?' do
    let(:subscription) { create(:subscription, reference: 'trial') }
    let(:perform) { subscription.expired? }

    context 'subscription is expired' do
      before { allow(subscription).to receive(:does_not_end_yet?).and_return(true) }
      it { expect(perform).to be_falsey }
    end

    context 'subscription is not expired' do
      before { allow(subscription).to receive(:does_not_end_yet?).and_return(false) }
      it { expect(perform).to be_truthy }
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

    context 'ends at is set to 8 days after current time' do
      let(:ends_at) { now + 8.days }
      it { expect(perform).to be_falsey }
    end

    context 'ends at is set to 7 days after current time' do
      let(:ends_at) { now + 7.days }
      it { expect(perform).to be_truthy }
    end

    context 'ends at is set to 2 days after current time' do
      let(:ends_at) { now + 2.days }
      it { expect(perform).to be_truthy }
    end

    context 'ends at is set to 1 hour before current time' do
      let(:ends_at) { now - 1.hour }
      it { expect(perform).to be_falsey }
    end
  end

  describe '#ends_within_few_days?' do
    let(:subscription) { create(:subscription, ends_at: ends_at) }
    let(:perform) { subscription.ends_within_few_days? }

    context 'ends at is nil' do
      let(:ends_at) { nil }
      it { expect(perform).to be_falsey }
    end

    context 'ends at is set to 3 days after current time' do
      let(:ends_at) { now + 3.days }
      it { expect(perform).to be_falsey }
    end

    context 'ends at is set to 1 days after current time' do
      let(:ends_at) { now + 1.days }
      it { expect(perform).to be_truthy }
    end

    context 'ends at is set to 1 hour before current time' do
      let(:ends_at) { now - 1.hour }
      it { expect(perform).to be_falsey }
    end
  end

  describe '#send_reminder!' do
    let!(:subscription) { create(:subscription, :trial, ends_at: ends_at, referrer: manager) }
    let(:manager) { create(:user, :manager, email: 'test@example.com') }
    let(:payment_url_base) { 'https://sites.fastspring.com/copenhagenapphouse/checkout/bettersalesman' }
    let(:payment_url_params) { "quantity=0&referrer=#{subscription.referrer.id}&contact_email=test%40example.com&contact_fname=+&contact_lname=+" }
    let(:payment_url) { "#{payment_url_base}?#{payment_url_params}" }
    let(:referrer) { subscription.referrer }
    let(:perform) { subscription.send_reminder! }

    before do
      allow(SubscriptionMailSender).to receive(:subscription_trial_expired)
      allow(SubscriptionMailSender).to receive(:subscription_critical_reminder)
      allow(SubscriptionMailSender).to receive(:subscription_gentle_reminder)
    end

    context 'ends at is nil' do
      let(:ends_at) { nil }
      it { expect { perform }.to_not change { subscription.send_reminder_at } }

      context 'after perform' do
        before { perform }

        it { expect(SubscriptionMailSender).to_not have_received(:subscription_trial_expired) }
        it { expect(SubscriptionMailSender).to_not have_received(:subscription_critical_reminder) }
        it { expect(SubscriptionMailSender).to_not have_received(:subscription_gentle_reminder) }
      end
    end

    context 'ends at is set to 8 days after current time' do
      let(:ends_at) { now + 8.days }
      it { expect { perform }.to_not change { subscription.send_reminder_at } }

      context 'after perform' do
        before { perform }

        it { expect(SubscriptionMailSender).to_not have_received(:subscription_trial_expired) }
        it { expect(SubscriptionMailSender).to_not have_received(:subscription_critical_reminder) }
        it { expect(SubscriptionMailSender).to_not have_received(:subscription_gentle_reminder) }
      end
    end

    context 'ends at is set to 5 days after current time' do
      let(:ends_at) { now + 5.days }
      it { expect { perform }.to change { subscription.send_reminder_at }.to(ends_at - 2.days) }

      context 'after perform' do
        before { perform }

        it { expect(SubscriptionMailSender).to_not have_received(:subscription_trial_expired) }
        it { expect(SubscriptionMailSender).to_not have_received(:subscription_critical_reminder) }
        it { expect(SubscriptionMailSender).to have_received(:subscription_gentle_reminder).with(referrer, payment_url) }
      end
    end

    context 'ends at is set to 3 days after current time' do
      let(:ends_at) { now + 3.days }
      it { expect { perform }.to change { subscription.send_reminder_at }.to(ends_at - 2.days) }

      context 'after perform' do
        before { perform }

        it { expect(SubscriptionMailSender).to_not have_received(:subscription_trial_expired) }
        it { expect(SubscriptionMailSender).to_not have_received(:subscription_critical_reminder) }
        it { expect(SubscriptionMailSender).to have_received(:subscription_gentle_reminder).with(referrer, payment_url) }
      end
    end

    context 'ends at is set to 1 day after current time' do
      let(:ends_at) { now + 1.day }
      it { expect { perform }.to change { subscription.send_reminder_at }.to(ends_at + 1.hour) }

      context 'after perform' do
        before { perform }

        it { expect(SubscriptionMailSender).to_not have_received(:subscription_trial_expired) }
        it { expect(SubscriptionMailSender).to have_received(:subscription_critical_reminder).with(referrer, payment_url) }
        it { expect(SubscriptionMailSender).to_not have_received(:subscription_gentle_reminder) }
      end
    end

    context 'ends at is set to 1 hour before current time' do
      let(:ends_at) { now - 1.hour }
      it { expect { perform }.to change { subscription.send_reminder_at }.to(nil) }

      context 'after perform' do
        before { perform }

        it { expect(SubscriptionMailSender).to have_received(:subscription_trial_expired).with(referrer, payment_url) }
        it { expect(SubscriptionMailSender).to_not have_received(:subscription_critical_reminder) }
        it { expect(SubscriptionMailSender).to_not have_received(:subscription_gentle_reminder) }
      end
    end

    context 'ends at is set to 1 day before current time' do
      let(:ends_at) { now - 1.day }
      it { expect { perform }.to change { subscription.send_reminder_at }.to(nil) }

      context 'after perform' do
        before { perform }

        it { expect(SubscriptionMailSender).to have_received(:subscription_trial_expired).with(referrer, payment_url) }
        it { expect(SubscriptionMailSender).to_not have_received(:subscription_critical_reminder) }
        it { expect(SubscriptionMailSender).to_not have_received(:subscription_gentle_reminder) }
      end
    end
  end
end
