describe Saasy::Api do
  describe '.authenticate_callback?' do
    let(:perform) { described_class.authenticate_callback?(security_data, security_hash) }
    let(:security_data) { '12345' }
    let(:private_key) { '67890' }
    let(:security_hash) { Digest::MD5.hexdigest("#{ security_data }#{ private_key }") }
    before { allow(ENV).to receive(:[]).with('SAASY_NOTIFICATION_KEY').and_return(env_private_key) }

    context 'valid security data' do
      let(:env_private_key) { private_key }
      it { expect(perform).to be_truthy }
    end

    context 'invalid security data' do
      let(:env_private_key) { 'wrong' }
      it { expect(perform).to be_falsey }
    end
  end
end
