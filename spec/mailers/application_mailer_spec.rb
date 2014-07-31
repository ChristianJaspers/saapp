require 'rails_helper'

describe ApplicationMailer do
  describe '#user_invitation' do
    let(:user) { create(:user, :unconfirmed_user) }
    let(:perform) { described_class.user_invitation(user) }

    it { expect { perform }.to change { user.reload.encrypted_password }.from('') }
    it { expect { perform }.to change { user.reload.confirmed_at }.from(nil) }
  end
end
