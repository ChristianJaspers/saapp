require 'rails_helper'

describe ColorCycleIterator do
  subject { described_class.new(values) }

  describe '.new' do
    context 'empty array' do
      let(:values) { [] }
      it { expect{ subject }.to raise_error(ArgumentError) }
    end

    context 'non empty array' do
      let(:values) { [1, 2, 3] }
      it { expect{ subject }.to_not raise_error }
    end
  end

  describe '#current' do
    let(:values) { [1, 2, 3] }

    it do
      expect(subject.current).to be_nil
      expect(subject.current).to be_nil
      subject.next
      expect(subject.current).to eq 1
      expect(subject.current).to eq 1
      subject.next
      expect(subject.current).to eq 2
      expect(subject.current).to eq 2
    end
  end

  describe '#next' do
    let(:values) { [1, 2, 3] }

    it do
      2.times do
        expect(subject.next).to eq 1
        expect(subject.next).to eq 2
        expect(subject.next).to eq 3
      end
    end
  end
end
