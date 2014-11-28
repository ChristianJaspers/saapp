require 'rails_helper'

describe Manager::DestroyProductGroup do
  describe '.call' do
    let(:current_user) { create(:user, :manager) }
    let(:product_group) { create(:product_group, owner: current_user) }
    let(:parameter_object) { {product_group: product_group, current_user: current_user} }
    let(:perform) { described_class.call(parameter_object) }

    before { allow(AllArgumentsPerUser).to receive(:send_to_team).and_call_original }

    it { expect { perform }.to change { product_group.remove_at }.from(nil) }

    context 'after perform' do
      before { perform }

      it { expect(AllArgumentsPerUser).to have_received(:send_to_team).with(current_user.team) }
    end
  end
end
