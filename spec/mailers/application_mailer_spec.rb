require 'rails_helper'

describe ApplicationMailer do
  describe '#user_invitation' do
    let(:user) { create(:user, :unconfirmed_user, display_name: 'Batman', invitation_message: 'Hello') }
    let(:perform) { described_class.user_invitation(user) }

    it { expect { perform }.to change { user.reload.encrypted_password }.from('') }
    it { expect { perform }.to change { user.reload.confirmed_at }.from(nil) }

    context 'after perform' do
      let(:expected_mapping) do
        {
          display_name: 'Batman',
          message: 'Hello'
        }
      end

      before do
        allow(EmailTemplates::Recipient).to receive(:new).and_call_original
        perform
      end

      it { expect(EmailTemplates::Recipient).to have_received(:new).with(user.locale, user.email, hash_including(expected_mapping)) }
    end
  end

  describe '#reset_user_password' do
    let(:user) { create(:user) }
    let(:perform) { described_class.reset_user_password(user) }
    before do
      expect_any_instance_of(EmailTemplates::Sender).to receive(:send)
    end

    it { expect { perform }.to change { user.reload.encrypted_password } }
  end
end
