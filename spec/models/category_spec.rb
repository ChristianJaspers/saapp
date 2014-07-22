require 'rails_helper'

describe Category do
  subject { category }

  describe '#removable_by?' do
    let(:perform) { subject.removable_by?(manager) }

    context 'for manager' do
      let(:manager) { create(:manager) }

      context 'manager is owner of category' do
        let(:category) { create(:category, owner: manager) }

        context 'category has feature' do
          before { create(:feature, category: category) }

          it { expect(perform).to be_truthy }
        end

        context 'category has no features' do
          it { expect(perform).to be_truthy }
        end
      end

      context 'manager is not owner of category' do
        let(:category) { create(:category) }

        context 'category has feature' do
          before { create(:feature, category: category) }

          it { expect(perform).to be_falsey }
        end

        context 'category has no features' do
          it { expect(perform).to be_truthy }
        end
      end
    end
  end

  describe '.purge_outdated_entries!' do
    let(:perform) { described_class.purge_outdated_entries! }

    context 'outdated, removed category exists' do
      before { create(:category, remove_at: Time.now - 1.day) }

      it { expect { perform }.to change { Category.unscoped.count }.by(-1) }
    end

    context 'regular category exists' do
      before { create(:category) }

      it { expect { perform }.not_to change { Category.unscoped.count } }
    end
  end
end
