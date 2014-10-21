require 'rails_helper'

describe Manager::UpdateUser do
  describe '.call' do
    let!(:api_token) { create(:api_token, user: user) }
    let(:user) { create(:user) }
    let(:parameter_object) { double(user: user, params: params) }
    let(:perform) { described_class.call(parameter_object) }

    context 'normal update' do
      let(:params) do
        {
          user: {
            display_name: 'Name'
          }
        }.with_indifferent_access
      end

      context 'after perform' do
        it { expect { perform }.to_not change{ user.reload.role } }
        it { expect { perform }.to_not change{ user.reload.reset_password_token } }
        it { expect { perform }.to_not change{ user.reload.api_token } }
      end
    end

    context 'becomes manager' do
      let(:params) do
        {
          user: {
            manager: '1'
          }
        }.with_indifferent_access
      end

      context 'after perform' do
        it { expect { perform }.to change{ user.reload.role }.from('user').to('manager') }
        it { expect { perform }.to change{ user.reload.reset_password_token }.from(nil) }
        it { expect { perform }.to change{ user.reload.api_token }.to(nil) }
      end
    end
  end
end
