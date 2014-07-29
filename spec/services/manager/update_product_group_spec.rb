require 'rails_helper'

describe Manager::UpdateProductGroup do
  describe '.call' do
    let(:current_user) { create(:manager) }
    let(:product_group) { create(:product_group, owner: current_user) }
    let!(:argument_to_update) { create(:argument, product_group: product_group, owner: current_user) }
    let!(:argument_to_remove) { create(:argument, product_group: product_group, owner: current_user) }
    let(:parameter_object) { double(product_group: product_group, params: params, current_user: current_user) }
    let(:perform) { described_class.call(parameter_object) }

    context 'update/create/remove' do
      let(:params) do
        {
            product_group: {
                name: 'Updated name!',
                arguments: [
                    {id: argument_to_update.id, description: 'Updated argument description!', benefit_description: 'Updated benefit description!'},
                    {description: 'New argument description!', benefit_description: 'New benefit description!'},
                ],
                arguments_to_remove_ids: [argument_to_remove.id]
            }
        }.with_indifferent_access
      end

      it { expect { perform }.to change { product_group.reload.name }.to 'Updated name!' }
      it { expect { perform }.to change { argument_to_update.reload.feature }.to 'Updated argument description!' }
      it { expect { perform }.to change { argument_to_update.reload.benefit }.to 'Updated benefit description!' }

      context 'after perform' do
        before { perform }

        it { expect(Argument).not_to exist.with(id: argument_to_remove.id) }
        it { expect(Argument).to exist.with(feature: 'New argument description!', benefit: 'New benefit description!') }
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
