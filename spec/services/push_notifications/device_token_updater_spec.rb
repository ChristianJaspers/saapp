require 'rails_helper'

describe PushNotifications::DeviceTokenUpdater do
  subject { described_class.new(user, params) }
  let!(:api_token) { create(:api_token) }
  let!(:api_token_similar) { create(:api_token) }
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
      it { expect { perform }.to_not change { api_token_similar.reload.notification_token } }
    end

    context 'device info exists' do
      let(:params) do
        {
          device_info: {
            notification_token: notification_token,
            platform: 'android',
            locale: 'pl'
          }
        }
      end

      context 'the same notification_token is sent' do
        let(:notification_token) { api_token.notification_token }

        it { expect { perform }.to change { api_token_similar.reload.notification_token }.to(nil) }
      end

      context 'new notification_token is sent' do
        let(:notification_token) { 'new-token' }

        it { expect { perform }.to change { api_token.reload.notification_token }.from('123').to('new-token') }
        it { expect { perform }.to change { api_token.reload.platform }.from('ios').to('android') }
        it { expect { perform }.to change { user.reload.locale }.from('en').to('pl') }
        it { expect { perform }.to_not change { api_token_similar.reload.notification_token } }
      end
    end
  end
end
