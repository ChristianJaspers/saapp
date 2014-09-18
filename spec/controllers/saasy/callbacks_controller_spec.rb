describe Saasy::CallbacksController do
  let(:call_request) { post :create, params }
  let(:security_data) { '12345' }
  let(:private_key) { '67890' }
  let(:security_hash) { Digest::MD5.hexdigest("#{ security_data }#{ private_key }") }

  before do
    allow(SubscriptionProcessor).to receive(:call).and_return(true)
    allow(ENV).to receive(:[]).with('SAASY_NOTIFICATION_KEY').and_return(env_private_key)
  end

  context 'valid security data' do
    let(:env_private_key) { private_key }
    let(:params) do
      {
        security_data: security_data,
        security_hash: security_hash
      }
    end

    context 'after request' do
      before { call_request }

      it { expect(SubscriptionProcessor).to have_received(:call).once }
      it { expect(response).to be_successful }
    end
  end

  context 'invalid security data' do
    let(:env_private_key) { 'wrong' }
    let(:params) do
      {
        security_data: security_data,
        security_hash: security_hash
      }
    end

    context 'after request' do
      before { call_request }

      it { expect(SubscriptionProcessor).to_not have_received(:call) }
      it { expect(response.status).to eq 403 }
    end
  end
end
