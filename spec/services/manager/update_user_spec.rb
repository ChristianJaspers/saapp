require 'rails_helper'

describe Manager::UpdateUser do
  describe '.call' do
    let(:user) { create(:user) }
    let(:params) do
      {
        user: {
          manager: '1'
        }
      }.with_indifferent_access
    end
    let(:parameter_object) { double(user: user, params: params) }
    let(:perform) { described_class.call(parameter_object) }

    context 'after perform' do
      it { expect { perform }.to change{ user.reload.role }.from('user').to('manager') }
      it { expect { perform }.to change{ user.reload.reset_password_token }.from(nil) }
    end
  end
end
