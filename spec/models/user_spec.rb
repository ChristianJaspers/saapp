require 'rails_helper'

describe User do
  describe '#admin?' do
    subject { user.admin? }

    context 'user is admin' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_truthy }
    end

    context 'user is not an admin' do
      let(:user) { create(:user) }

      it { is_expected.to be_falsy }
    end
  end

  describe '.create' do
    context 'with no password provided' do
      xit 'user can be created' #remove temporary password from SetupNewAccount when this is implemented
    end
  end

  describe '.authenticate' do
    let(:user) { create(:user, email: 'user@test.com') }
    subject { described_class.authenticate(email, password) }

    context 'email exists' do
      let(:email) { user.email }

      context 'valid credentials' do
        let(:password) { '12345678' }

        it { is_expected.to eq user }
      end

      context 'invalid credentials' do
        let(:password) { 'invalid password' }

        it { is_expected.to be_nil }
      end
    end

    context 'email does not exist' do
      let(:email) { 'fake@test.com' }
      let(:password) { 'whatever' }

      it { is_expected.to be_nil }
    end
  end
end
