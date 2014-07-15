require 'rails_helper'

describe EmailTemplates::BuildTemplateName do
  describe '.call' do
    subject { described_class.call('en', 'my_template') }
    it { is_expected.to eq 'en-my_template' }
  end
end
