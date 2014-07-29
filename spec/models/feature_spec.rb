require 'rails_helper'

describe Feature do
  describe '#rated?' do
    context 'feature was not rated' do
      it do
        pending 'To be implemented'
        expect(subject.rated?).to be_falsey
        fail
      end
    end

    context 'feature was rated' do
      it do
        pending 'To be implemented'
        expect(subject.rated?).to be_truthy
        fail
      end
    end
  end

  describe '#save' do
    let(:feature_creator) { create(:user) }
    let(:feature) { build(:feature, owner: feature_creator) }
    let(:perform) { feature.save }

    context 'logged in as feature creator' do
      before { allow(User).to receive(:current).and_return(feature_creator) }

      it { expect { perform }.to change { Gamification::Scoring.count }.by(1) }

      context 'after perform' do
        before { perform }

        describe 'feature creator scoring' do
          subject { feature_creator.scorings.last }

          its(:amount) { is_expected.to eq 2 }
        end
      end
    end
  end
end
