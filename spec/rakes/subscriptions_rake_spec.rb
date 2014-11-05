require 'rails_helper'
require 'rake'
require 'mandrill'

shared_context "rake subscriptions:send_trial_expiration_reminders" do
  let(:rake_task_name) { 'subscriptions:send_trial_expiration_reminders' }

  context 'company has trial subscription' do
    let(:manager) { create(:manager, locale: locale) }
    let(:company) { manager.team.company }
    let(:subscription) { company.subscriptions.first }

    before do
      create(:manager, team: manager.team, locale: 'pl')
      Subscription.start_trial_for_manager(manager)
    end

    it { expect(company).to have(1).subscription }

    context '8 days before trail expires' do
      let(:perform_rake_at) { subscription.ends_at - 8.days }

      it { expect { perform_rake }.to_not change { subscription.reload.send_reminder_at } }
    end

    context '6 days before trail expires' do
      let(:perform_rake_at) { subscription.ends_at - 6.days }

      it { expect { perform_rake }.to change { subscription.reload.send_reminder_at } }

      context 'after perform' do
        before do
          allow(SubscriptionMailSender).to receive(:subscription_gentle_reminder).and_call_original
          expect_any_instance_of(Mandrill::Messages).to receive(:send_template).with(
            "#{locale}-subscription_gentle_reminder", anything, anything, anything, anything, anything
          )
          perform_rake
        end

        it { expect(SubscriptionMailSender).to have_received(:subscription_gentle_reminder) }
      end
    end

    context '2 days before trail expires' do
      let(:perform_rake_at) { subscription.ends_at - 2.days }

      it { expect { perform_rake }.to change { subscription.reload.send_reminder_at } }

      context 'after perform' do
        before do
          allow(SubscriptionMailSender).to receive(:subscription_critical_reminder).and_call_original
          expect_any_instance_of(Mandrill::Messages).to receive(:send_template).with(
            "#{locale}-subscription_critical_reminder", anything, anything, anything, anything, anything
          )
          perform_rake
        end

        it { expect(SubscriptionMailSender).to have_received(:subscription_critical_reminder) }
      end
    end

    context '1.minute after trail expired' do
      let(:perform_rake_at) { subscription.ends_at + 1.minute }

      it { expect { perform_rake }.to change { subscription.reload.send_reminder_at } }

      context 'after perform' do
        before do
          allow(SubscriptionMailSender).to receive(:subscription_trial_expired).and_call_original
          expect_any_instance_of(Mandrill::Messages).to receive(:send_template).with(
            "#{locale}-subscription_trial_expired", anything, anything, anything, anything, anything
          )
          perform_rake
        end

        it { expect(SubscriptionMailSender).to have_received(:subscription_trial_expired) }
      end
    end
  end
end

describe 'subscriptions rake' do
  before :all do
    Rake.application.rake_require 'tasks/subscriptions'
    Rake::Task.define_task(:environment)
  end
  before do
    travel_to Time.new(2014, 1, 1, 12, 0)
    allow_any_instance_of(Mandrill::Messages).to receive(:send_template).and_return({})
  end
  after { travel_back }

  let(:perform) do
    Rake::Task[rake_task_name].reenable
    Rake.application.invoke_task rake_task_name
  end
  let(:perform_rake) { travel_to(perform_rake_at) { perform } }

  describe 'send_trial_expiration_reminders' do
    context 'locale is EN' do
      let(:locale) { 'en' }
      include_context 'rake subscriptions:send_trial_expiration_reminders'
    end

    context 'locale is DA' do
      let(:locale) { 'da' }
      include_context 'rake subscriptions:send_trial_expiration_reminders'
    end
  end
end
