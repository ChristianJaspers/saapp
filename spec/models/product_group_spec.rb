require 'rails_helper'

describe ProductGroup do
  subject { product_group }

  describe '#save' do
    let(:product_group) { build(:product_group) }

    it { expect(product_group.team).to be_nil }

    context 'after perform' do
      before { product_group.save }

      it { expect(product_group.team).to eq product_group.owner.team }
      it { expect(product_group.team).to_not be_nil }
    end
  end

  describe '#removable_by?' do
    let(:perform) { subject.removable_by?(manager) }

    context 'for manager' do
      let(:manager) { create(:manager) }

      context 'manager is owner of product_group' do
        let(:product_group) { create(:product_group, owner: manager) }

        context 'product_group has argument' do
          before { create(:argument, product_group: product_group) }

          it { expect(perform).to be_truthy }
        end

        context 'product_group has no arguments' do
          it { expect(perform).to be_truthy }
        end
      end

      context 'manager is not owner of product_group' do
        let(:product_group) { create(:product_group) }

        context 'product_group has argument' do
          before { create(:argument, product_group: product_group) }

          it { expect(perform).to be_falsey }
        end

        context 'product_group has no arguments' do
          it { expect(perform).to be_truthy }
        end
      end
    end
  end

  describe '.purge_outdated_entries!' do
    let(:perform) { described_class.purge_outdated_entries! }

    context 'outdated, removed product_group exists' do
      before { create(:product_group, remove_at: Time.now - 1.day) }

      it { expect { perform }.to change { ProductGroup.unscoped.count }.by(-1) }
    end

    context 'regular product_group exists' do
      before { create(:product_group) }

      it { expect { perform }.not_to change { ProductGroup.unscoped.count } }
    end
  end
end
