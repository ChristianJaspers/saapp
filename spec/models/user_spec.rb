require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#admin?' do
    let(:user) { create(:user) }

    subject { user.admin? }

    context 'user is admin' do
      before { user.update_column(:role, 'admin') }
      it { is_expected.to be_truthy }
    end

    context 'user is not an admin' do
      it { is_expected.to be_falsy }
    end
  end
end
