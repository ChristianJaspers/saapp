require 'rails_helper'

describe WhitelistLocale do
  describe '.call' do
    let(:perform) { described_class.call(locale) }

    context 'en' do
      it { expect(described_class.call('en')).to eq :en }
      it { expect(described_class.call(:en)).to eq :en }
    end

    context 'da' do
      it { expect(described_class.call('da')).to eq :da }
      it { expect(described_class.call(:da)).to eq :da }
    end

    context 'pl' do
      it { expect(described_class.call('pl')).to eq :en }
      it { expect(described_class.call(:pl)).to eq :en }
    end

    context 'empty or invalid cases' do
      it { expect(described_class.call('')).to eq :en }
      it { expect(described_class.call(nil)).to eq :en }
      it { expect(described_class.call(1)).to eq :en }
      it { expect(described_class.call(':')).to eq :en }
      it { expect(described_class.call('en-pl')).to eq :en }
      it { expect(described_class.call('pl-en')).to eq :en }
    end
  end
end
