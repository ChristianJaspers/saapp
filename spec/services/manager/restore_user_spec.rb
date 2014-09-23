require 'rails_helper'

describe Manager::RestoreUser do
  describe '#call' do
    let(:perform) { described_class.new(email, restorer).call }

    context 'user not found' do
      context 'after perform' do
        before { perform }
        let!(:restorer) { create(:user, :manager) }
        let!(:restoree) { create(:user, team_id: restorer.team_id, remove_at: Time.now) }
        let(:email) { restoree.email + 'x' }

        it { expect { perform }.to_not change { restoree.reload.remove_at } }
      end
    end

    context 'user is scheduled to be removed' do
      context 'user is from the same company' do
        let!(:restorer) { create(:user, :manager) }
        let!(:restoree) { create(:user, team: restorer.team, remove_at: Time.now) }
        let(:email) { restoree.email }

        it { expect { perform }.to change { restoree.reload.remove_at }.to(nil) }
      end

      context 'user is from different company' do
        let!(:restorer) { create(:user, :manager) }
        let!(:restoree) { create(:user, team_id: restorer.team_id + 1, remove_at: Time.now) }
        let(:email) { restoree.email }

        it { expect { perform }.to_not change { restoree.reload.remove_at } }
      end
    end

  end
end
