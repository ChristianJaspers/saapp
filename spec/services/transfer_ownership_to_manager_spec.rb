require 'rails_helper'

describe TransferOwnershipToManager do
  describe '.call' do
    let(:user) { create(:user) }
    let(:perform) { described_class.call(user: user) }

    context 'user is owner to product groups and arguments' do
      let!(:manager) { create(:manager, team: user.team) }
      let!(:product_group) { create(:product_group, owner_id: user.id) }
      let!(:argument_1) { create(:argument, owner_id: user.id) }
      let!(:argument_2) { create(:argument, owner_id: user.id) }

      it { expect{ perform }.to change { product_group.reload.owner_id }.from(user.id).to(manager.id) }
      it { expect{ perform }.to change { argument_1.reload.owner_id }.from(user.id).to(manager.id) }
      it { expect{ perform }.to change { argument_2.reload.owner_id }.from(user.id).to(manager.id) }
    end
  end
end
