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

      it { is_expected.to be_falsey }
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

  describe '#manager' do
    subject { user }

    context 'normal user' do
      let(:user) { create(:user) }
      its(:manager) { is_expected.to be_falsey }
    end

    context 'manager' do
      let(:user) { create(:manager) }
      its(:manager) { is_expected.to be_truthy }
    end
  end

  describe '#manager=' do
    let(:user) { create(:user) }
    subject { user.role }
    before { user.manager = assigned_value }

    context 'true value is assigned' do
      let(:assigned_value) { true }
      it { is_expected.to eq 'manager' }
    end

    context 'false value is assigned' do
      let(:assigned_value) { false }
      it { is_expected.to eq 'user' }
    end
  end

  describe '#remove!' do
    let(:user) { create(:user) }
    subject { user }

    it { expect{ subject.remove! }.to change{ subject.reload.remove_at }.from(nil) }
  end

  describe '#score' do
    subject { create(:user) }

    context 'two-point scoring exists' do
      before { create(:gamification_scoring, beneficiary_id: subject.id, amount: 2) }

      its(:score) { is_expected.to eq 2 }

      context 'additional two-point scoring exists' do
        before { create(:gamification_scoring, beneficiary_id: subject.id, amount: 2) }

        its(:score) { is_expected.to eq 4 }
      end
    end

    context 'two-point scoring exists' do
      before { create(:gamification_scoring, beneficiary_id: subject.id, amount: 2, created_at: creation_date) }

      context 'for requested period between 26-07-2014 and 28-07-2014' do
        let(:requested_period) { (DateTime.parse('26-07-2014')..DateTime.parse('28-07-2014')) }

        context 'two-point scoring exists outside of requested period' do
          let(:creation_date) { DateTime.parse('25-07-2014') }

          it { expect(subject.score(period: requested_period)).to eq 0 }
        end

        context 'two-point scoring exists within of requested period' do
          let(:creation_date) { DateTime.parse('27-07-2014') }

          it { expect(subject.score(period: requested_period)).to eq 2 }
        end
      end
    end
  end
end
