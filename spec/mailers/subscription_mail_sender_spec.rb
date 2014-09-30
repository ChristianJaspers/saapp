require 'rails_helper'

shared_examples 'SubscriptionMailSender that sends template' do
  context 'after perform' do
    before do
      expect_any_instance_of(EmailTemplates::Sender).to receive(:send)
      perform
    end

    it { expect(EmailTemplates::Recipient).to have_received(:new).with('en', 'test@example.com', {payment_url: payment_url}) }
    it { expect(EmailTemplates::Sender).to have_received(:new).with([kind_of(EmailTemplates::Recipient)], template_key)  }
  end
end

describe SubscriptionMailSender do
  let(:user) { create(:user, :manager, email: 'test@example.com') }
  let(:payment_url) { 'http://pay.me' }

  before do
    allow_any_instance_of(EmailTemplates::Sender).to receive(:send)
    allow(EmailTemplates::Recipient).to receive(:new).and_call_original
    allow(EmailTemplates::Sender).to receive(:new).and_call_original
  end

  describe '.subscription_gentle_reminder' do
    let(:perform) { described_class.subscription_gentle_reminder(user, payment_url) }
    let(:template_key) { :subscription_gentle_reminder }

    it_behaves_like 'SubscriptionMailSender that sends template'
  end

  describe '.subscription_critical_reminder' do
    let(:perform) { described_class.subscription_critical_reminder(user, payment_url) }
    let(:template_key) { :subscription_critical_reminder }

    it_behaves_like 'SubscriptionMailSender that sends template'
  end

  describe '.subscription_trial_expired' do
    let(:perform) { described_class.subscription_trial_expired(user, payment_url) }
    let(:template_key) { :subscription_trial_expired }

    it_behaves_like 'SubscriptionMailSender that sends template'
  end

  describe '.account_will_be_deleted' do
    let(:perform) { described_class.account_will_be_deleted(user, payment_url) }
    let(:template_key) { :account_will_be_deleted }

    it_behaves_like 'SubscriptionMailSender that sends template'
  end
end
