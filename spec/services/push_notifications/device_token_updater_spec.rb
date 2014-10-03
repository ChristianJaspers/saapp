require 'rails_helper'

describe PushNotifications::DeviceTokenUpdater do
  subject { described_class.new(user, params) }
  let(:api_token) { create(:api_token) }
  let(:user) { create(:user, api_token: api_token) }

  describe '#perform' do
    let(:perform) { subject.perform }

    context 'device info does not exist' do
      let(:params) do
        {}
      end

      it { expect { perform }.to_not change { api_token.reload.notification_token } }
      it { expect { perform }.to_not change { api_token.reload.platform } }
      it { expect { perform }.to_not change { user.reload.locale } }
    end

    context 'device info exists' do
      let(:params) do
        {
          device_info: {
            notification_token: 'new-token',
            platform: 'android',
            locale: 'pl'
          }
        }
      end

      it { expect { perform }.to change { api_token.reload.notification_token }.from('123').to('new-token') }
      it { expect { perform }.to change { api_token.reload.platform }.from('ios').to('android') }
      it { expect { perform }.to change { user.reload.locale }.from('en').to('pl') }
    end
  end
end
