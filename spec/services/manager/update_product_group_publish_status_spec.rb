require 'rails_helper'

describe Manager::UpdateProductGroupPublishStatus do
  describe '.call' do
    let(:current_user) { create(:manager) }
    let(:product_group) { create(:product_group, owner: current_user, archived_at: archived_at) }
    let(:parameter_object) { double(product_group: product_group, params: params, current_user: current_user) }
    let(:perform) { described_class.call(parameter_object) }

    before do
      allow(AllArgumentsPerUser).to receive(:send_to_team)
    end

    context 'product group is archived' do
      let(:archived_at) { Time.now }
      let(:params) do
        {
          product_group: {archive: nil}
        }.with_indifferent_access
      end

      it { expect { perform }.to change { product_group.reload.archived_at }.to nil }

      context 'after perform' do
        before { perform }

        it { expect(AllArgumentsPerUser).to have_received(:send_to_team).with(current_user.team) }
      end
    end

    context 'product group is not archived' do
      let(:archived_at) { nil }
      let(:params) do
        {
          product_group: {archive: 'true'}
        }.with_indifferent_access
      end

      it { expect { perform }.to change { product_group.reload.archived_at }.from nil }

      context 'after perform' do
        before { perform }

        it { expect(AllArgumentsPerUser).to have_received(:send_to_team).with(current_user.team) }
      end
    end
  end
end
