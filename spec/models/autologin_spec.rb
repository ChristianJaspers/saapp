require 'rails_helper'

RSpec.describe Autologin, type: :model do
  before { travel_to Time.now }
  after { travel_back }

  describe '.generate_for_user' do
    let(:user) { create(:user) }
    let(:perform) { described_class.generate_for_user(user) }

    it { expect(perform.token).to_not be_nil }
    it { expect(perform.expires_at).to eq Time.now + 30.minutes }
    it { expect(perform.id).to_not be_nil }
  end

  describe '.authenticate_user' do
    let(:autologin) { create(:autologin) }
    let(:perform) { described_class.authenticate_user(token) }

    context 'valid token' do
      let(:token) { autologin.token }

      it { expect(perform).to eq autologin.user }
    end

    context 'invalid token' do
      let(:token) { 'wrong' }

      it { expect(perform).to be_nil }
    end
  end
end
