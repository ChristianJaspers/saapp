require 'rails_helper'

RSpec.describe User, type: :model do
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
end
