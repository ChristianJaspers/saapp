require 'rails_helper'

describe GenerateRandomPassword do
  describe '.call' do
    subject { described_class.call }

    it { is_expected.to be_present }
  end
end
