require 'rails_helper'

describe Manager::CreateUser do
  describe '.call' do
    let!(:current_user) { create(:user, :manager) }
    let(:parameter_object) { {user: user, current_user: current_user} }
    let(:email) { 'fake@email.com' }
    let(:perform) { described_class.call(parameter_object) }

    before do
      allow(ApplicationMailer).to receive(:user_invitation).and_return(true)
      allow_any_instance_of(SubscriptionUpdater).to receive(:success?).and_return(true)
      allow_any_instance_of(SubscriptionUpdater).to receive(:update_remote_subscription).and_return(true)
      allow(SubscriptionUpdater).to receive(:call).and_call_original
    end

    context 'after perform' do
      let!(:user) { build(:user, email: email, team_id: current_user.team_id) }

      before { perform }

      it { expect(ApplicationMailer).to have_received(:user_invitation).with(User.user.last) }
      it { expect(user.reload.instance_variable_get('@skip_confirmation_notification')).to be_truthy }
      it { expect(User).to exist.with(email: email) }
      it { expect(SubscriptionUpdater).to have_received(:call).with(user: user).once }
    end

    context 'user is removed' do
      let!(:deleted_user) { create(:user, email: email, team_id: current_user.team_id, remove_at: Time.now, display_name: 'Old John') }
      let!(:user) { build(:user, email: email, team_id: current_user.team_id, display_name: 'New john') }

      it { expect { perform }.to change { deleted_user.reload.remove_at }.to(nil) }

      context 'after perform' do
        before { perform }

        it { expect(ApplicationMailer).to have_received(:user_invitation).with(deleted_user) }
        it { expect(User).to exist.with(email: email) }
        it { expect(SubscriptionUpdater).to have_received(:call).with(user: deleted_user).once }
      end
    end

    context 'user with locales' do
      let!(:user) { build(:user, email: email, team_id: current_user.team_id) }

      context 'manager locale is en' do
        before do
          allow(current_user).to receive(:locale).and_return('en')
          perform
        end

        it { expect(User.user.last.locale).to eq 'en' }
      end

      context 'manager locale is da' do
        before do
          allow(current_user).to receive(:locale).and_return('da')
          perform
        end

        it { expect(User.user.last.locale).to eq 'da' }
      end
    end
  end
end
