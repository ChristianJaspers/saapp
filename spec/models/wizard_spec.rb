require 'rails_helper'

describe Wizard do
  subject { described_class.new }

  describe '#valid?' do
    context 'no email present' do
      before { subject.email = ''}

      its(:valid?){ is_expected.to be_falsey }
    end

    context 'invalid email present' do
      before { subject.email = 'person'}

      its(:valid?){ is_expected.to be_falsey }
    end

    context 'email present' do
      before { subject.email = 'person@example.dev'}

      its(:valid?){ is_expected.to be_truthy }
    end
  end
end
