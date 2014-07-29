require 'rails_helper'

describe Argument do
  describe '#rated?' do
    context 'argument was not rated' do
      it do
        pending 'To be implemented'
        expect(subject.rated?).to be_falsey
        fail
      end
    end

    context 'argument was rated' do
      it do
        pending 'To be implemented'
        expect(subject.rated?).to be_truthy
        fail
      end
    end
  end

  describe '#save' do
    let(:argument_creator) { create(:user) }
    let(:argument) { build(:argument, owner: argument_creator) }
    let(:perform) { argument.save }

    context 'logged in as argument creator' do
      before { allow(User).to receive(:current).and_return(argument_creator) }

      it { expect { perform }.to change { Gamification::Scoring.count }.by(1) }

      context 'after perform' do
        before { perform }

        describe 'argument creator scoring' do
          subject { argument_creator.scorings.last }

          its(:amount) { is_expected.to eq 2 }
        end
      end
    end
  end
end
