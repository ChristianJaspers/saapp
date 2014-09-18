require 'rails_helper'

describe Manager::CreateUser do
  describe '.call' do
    let(:user) { build(:user, email: 'fake@email.com') }
    let(:parameter_object) { double(user: user) }
    let(:perform) { described_class.call(parameter_object) }

    before { allow(ApplicationMailer).to receive(:user_invitation) }

    context 'after perform' do
      before { perform }

      it { expect(ApplicationMailer).to have_received(:user_invitation).with(User.user.last) }
      it { expect(user.reload.instance_variable_get('@skip_confirmation_notification')).to be_truthy }
      it { expect(User).to exist.with(email: 'fake@email.com') }

      pending 'remote subscription is updated'

      pending 'trial subscription is not updated'
    end
  end
end
