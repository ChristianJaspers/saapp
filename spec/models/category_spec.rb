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
end
