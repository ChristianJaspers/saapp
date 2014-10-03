require 'rails_helper'

describe PushNotifications::Sender do
  subject { described_class.new(params) }
  before do
    create(:rpush_app)
  end

  describe '#send' do
    let(:valid_notification_token_1) { '1' * 64 }
    let(:valid_notification_token_2) { '2' * 64 }
    let(:user_1) { create(:user, api_token: create(:api_token, notification_token: valid_notification_token_1)) }
    let(:user_2) { create(:user, api_token: create(:api_token, notification_token: valid_notification_token_2)) }

    let(:params) do
      {
        user_1.id => 1,
        user_2.id => 2
      }
    end

    context 'after perform' do
      before { subject.send }

      let(:apn_1) { Rpush::Apns::Notification.first }
      let(:apn_2) { Rpush::Apns::Notification.last }

      it { expect(apn_1.badge).to eq 1 }
      it { expect(apn_2.badge).to eq 2 }
      it { expect(apn_1.device_token).to eq '1' * 64 }
      it { expect(apn_2.device_token).to eq '2' * 64 }
    end
  end
end
