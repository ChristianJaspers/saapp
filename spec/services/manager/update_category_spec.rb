require 'rails_helper'

describe Manager::UpdateCategory do
  describe '.call' do
    let(:current_user) { create(:manager) }
    let(:category) { create(:category, owner: current_user) }
    let!(:feature_to_update) { create(:feature, category: category, owner: current_user) }
    let!(:benefit_to_update) { create(:benefit, feature: feature_to_update) }
    let!(:feature_to_remove) { create(:feature, category: category, owner: current_user) }
    let!(:benefit_to_remove) { create(:benefit, feature: feature_to_remove) }
    let(:parameter_object) { double(category: category, params: params, current_user: current_user) }
    let(:perform) { described_class.call(parameter_object) }

    context 'update/create/remove' do
      let(:params) do
        {
            category: {
                name: 'Updated name!',
                arguments: [
                    {id: feature_to_update.id, description: 'Updated feature description!', benefit_description: 'Updated benefit description!'},
                    {description: 'New feature description!', benefit_description: 'New benefit description!'},
                ],
                arguments_to_remove_ids: [feature_to_remove.id]
            }
        }.with_indifferent_access
      end

      it { expect { perform }.to change { category.reload.name }.to 'Updated name!' }
      it { expect { perform }.to change { feature_to_update.reload.description }.to 'Updated feature description!' }
      it { expect { perform }.to change { benefit_to_update.reload.description }.to 'Updated benefit description!' }

      context 'after perform' do
        before { perform }

        it { expect(Feature).not_to exist.with(id: feature_to_remove.id) }
        it { expect(Benefit).not_to exist.with(id: benefit_to_remove.id) }
        it { expect(Feature).to exist.with(description: 'New feature description!') }
        it { expect(Benefit).to exist.with(description: 'New benefit description!') }
      end
    end

    context 'removing all arguments' do
      let(:params) do
        {
            category: {
                name: 'Updated name!',
                arguments_to_remove_ids: [feature_to_remove.id]
            }
        }.with_indifferent_access
      end

      it { expect { perform }.to change { Feature.count }.by(-1) }
      it { expect { perform }.to change { Benefit.count }.by(-1) }
    end
  end
end
