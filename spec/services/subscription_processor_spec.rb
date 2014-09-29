require 'rails_helper'

describe SubscriptionProcessor do
  describe '.call' do
    before { travel_to(Time.new(2014, 7, 30, 12, 0, 0, "+00:00")) }
    after { travel_back }
    let(:team) { create(:team) }
    let!(:company) { team.company }
    let(:manager) { create(:user, :manager, team: team) }
    let(:parameter_object) { double(params: params) }
    let(:perform) { described_class.call(parameter_object) }
    let(:fsprg_subscription) { build(:fsprg_subscription) }
    let(:valid_reference) { fsprg_subscription.reference }
    let(:invalid_reference) { 'wrong' }

    before do
      allow_any_instance_of(Saasy::ApiModules::Subscription).to receive(:find).with(valid_reference).and_return(fsprg_subscription)
      allow_any_instance_of(Saasy::ApiModules::Subscription).to receive(:find).with(invalid_reference).and_return(nil)
    end

    context 'invalid params' do
      context 'invalid reference' do
        let(:params) do
          HashWithIndifferentAccess.new({
            'SubscriptionReferrer' => manager.id,
            'SubscriptionReference' => invalid_reference
          })
        end

        it { expect { perform }.to_not change { Subscription.count } }
      end

      context 'invalid referrer' do
        let(:params) do
          HashWithIndifferentAccess.new({
            'SubscriptionReferrer' => manager.id + 1,
            'SubscriptionReference' => valid_reference
          })
        end

        it { expect { perform }.to_not change { Subscription.count } }
      end
    end

    context 'valid params' do
      let(:params) do
        HashWithIndifferentAccess.new({
          'SubscriptionReferrer' => manager.id,
          'SubscriptionReference' => valid_reference
        })
      end

      context 'there is no subscription yet' do
        let(:subscription) { Subscription.last }

        it { expect { perform }.to change { Subscription.count }.from(0).to(1) }

        context 'after process' do
          before { perform }

          it { expect(subscription.referrer).to eq manager }
          it { expect(subscription.company).to eq manager.company }
          it { expect(subscription.reference).to eq valid_reference }
          it { expect(subscription.quantity).to eq 3 }
          it { expect(subscription.status).to eq 'active' }
          it { expect(subscription.ends_at).to be_nil }
          it { expect(subscription.is_test).to be_nil }
        end

        context 'has remove at' do
          before { company.update_column(:remove_at, Time.now) }
          it { expect { perform }.to change { company.reload.remove_at }.from(Time.now.to_date).to(nil) }
        end

        context 'with end date' do
          before do
            fsprg_subscription.end_date = Time.now.to_date + 5.days
          end

          it { expect { perform }.to change { company.reload.remove_at }.from(nil).to(Time.now.to_date + (6 * 30 + 5).days) }

          context 'after process' do
            before { perform }

            it { expect(subscription.ends_at).to_not be_nil }
          end
        end

        context 'with test' do
          before do
            fsprg_subscription.test = true
            perform
          end

          it { expect(subscription.is_test).to be_truthy }
        end
      end

      context 'subscription already exists' do
        before do
          create(:subscription, company: manager.company, reference: valid_reference, quantity: 10)
        end

        let(:subscription) { Subscription.last }

        it { expect { perform }.to_not change { Subscription.count } }

        context 'after process' do
          before { perform }

          it { expect(subscription.referrer).to eq manager }
          it { expect(subscription.company).to eq manager.company }
          it { expect(subscription.reference).to eq valid_reference }
          it { expect(subscription.quantity).to eq 3 }
          it { expect(subscription.status).to eq 'active' }
          it { expect(subscription.ends_at).to be_nil }
        end
      end
    end
  end
end
