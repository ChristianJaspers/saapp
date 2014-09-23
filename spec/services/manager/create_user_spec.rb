require 'rails_helper'

describe Manager::CreateUser do
  describe '.call' do
    let(:current_user) { create(:user, :manager) }
    let(:user) { build(:user, email: 'fake@email.com', team_id: current_user.team_id) }
    let(:parameter_object) { double(user: user, current_user: current_user) }
    let(:perform) { described_class.call(parameter_object) }

    before do
      allow(ApplicationMailer).to receive(:user_invitation).and_return(true)
      allow_any_instance_of(SubscriptionUpdater).to receive(:success?).and_return(true)
      allow_any_instance_of(SubscriptionUpdater).to receive(:update_remote_subscription).and_return(true)
      allow(SubscriptionUpdater).to receive(:call).and_call_original
    end

    context 'after perform' do
      before { perform }

      it { expect(ApplicationMailer).to have_received(:user_invitation).with(User.user.last) }
      it { expect(user.reload.instance_variable_get('@skip_confirmation_notification')).to be_truthy }
      it { expect(User).to exist.with(email: 'fake@email.com') }
      it { expect(SubscriptionUpdater).to have_received(:call).with(user: user).once }
    end
  end
end
