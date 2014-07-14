require 'rails_helper'

describe EmailTemplates::TemplateNameBuilder do
  describe '.build' do
    subject { described_class.build('en', 'my_template') }
    it { is_expected.to eq 'en-my_template' }
  end
end
