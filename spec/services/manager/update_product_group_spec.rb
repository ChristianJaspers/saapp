require 'rails_helper'

describe Manager::UpdateProductGroup do
  describe '.call' do
    let(:current_user) { create(:manager) }
    let(:product_group) { create(:product_group, owner: current_user) }
    let!(:argument_to_update) { create(:argument, product_group: product_group, owner: current_user) }
    let!(:argument_rating){ argument_to_update.ratings.create(rater: create(:user), rating: 1) }
    let!(:argument_to_remove) { create(:argument, product_group: product_group, owner: current_user) }
    let(:parameter_object) { double(product_group: product_group, params: params, current_user: current_user) }
    let(:perform) { described_class.call(parameter_object) }
    before do
      allow(AllArgumentsPerUser).to receive(:send_to_team)
    end

    context 'update/create/remove' do
      let(:params) do
        {
            product_group: {
                name: 'Updated name!',
                arguments: [
                    {id: argument_to_update.id, feature: 'Updated argument description!', benefit: 'Updated benefit description!'},
                    {feature: 'New argument description!', benefit: 'New benefit description!'},
                ],
                arguments_to_remove_ids: [argument_to_remove.id]
            }
        }.with_indifferent_access
      end

      it { expect { perform }.to change { product_group.reload.name }.to 'Updated name!' }
      it { expect { perform }.to change { argument_to_update.reload.feature }.to 'Updated argument description!' }
      it { expect { perform }.to change { argument_to_update.reload.benefit }.to 'Updated benefit description!' }
      it { expect { perform }.to change { argument_to_update.reload.rating }.to nil }

      context 'after perform' do
        before { perform }

        it { expect(AllArgumentsPerUser).to have_received(:send_to_team).with(current_user.team) }
        it { expect(Argument).to exist.with(feature: 'New argument description!', benefit: 'New benefit description!') }
        it { expect(argument_to_remove).not_to exist }
        it { expect(argument_rating).not_to exist }
      end
    end

    context 'removing all arguments' do
      let(:params) do
        {
            product_group: {
                name: 'Updated name!',
                arguments_to_remove_ids: [argument_to_remove.id]
            }
        }.with_indifferent_access
      end

      it { expect { perform }.to change { Argument.count }.by(-1) }
    end
  end
end
