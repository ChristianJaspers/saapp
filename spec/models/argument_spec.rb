require 'rails_helper'

describe Argument do
  subject { create(:argument) }

  describe '.ratings#create' do
    let(:perform) { subject.ratings.create(rating: :low, rater_id: create(:user).id) }

    it { expect { perform }.to change { subject.reload.rating }.from(nil).to(1.0) }
  end

  describe '#rated?' do
    context 'argument was not rated' do
      its(:rated?) { is_expected.to be_falsey }
    end

    context 'argument was rated' do
      before { subject.ratings.create(rating: :low, rater_id: create(:user).id) }

      its(:rated?) { is_expected.to be_truthy }
    end
  end

  describe '#save' do
    let(:argument_creator) { create(:user) }
    let(:argument) { build(:argument, owner: argument_creator) }
    let(:perform) { argument.save }

    it { expect { perform }.to change { Gamification::Scoring.count }.by(1) }

    context 'after perform' do
      before { perform }

      describe 'argument creator scoring' do
        subject { argument_creator.scorings.last }

        its(:amount) { is_expected.to eq 9 }
      end
    end
  end
end
