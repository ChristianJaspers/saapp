require 'rails_helper'

describe Api::ErrorMapping do
  subject { described_class.new(error_key) }

  describe '#http_code' do
    let(:perform) { subject.http_code }

    context ':not_authenticated' do
      let(:error_key) { :not_authenticated }
      it { expect(perform).to eq 401 }
    end
  end

  describe '#internal_code' do
    let(:perform) { subject.internal_code }

    context ':not_authenticated' do
      let(:error_key) { :not_authenticated }
      it { expect(perform).to eq 1103 }
    end
  end

  describe '#message' do
    let(:perform) { subject.message }

    context ':not_authenticated' do
      let(:error_key) { :not_authenticated }
      it { expect(perform).to eq 'Wrong credentials' }
    end
  end

  describe '#to_hash' do
    let(:perform) { subject.to_hash }
    let(:error_key) { :not_authenticated }

    it 'returns error hash' do
      expect(perform).to eq({
        error: {
          code: 1103,
          message: 'Wrong credentials'
        }
      })
    end
  end

  describe '#to_json' do
    let(:perform) { subject.to_json }
    let(:error_key) { :not_authenticated }

    it 'returns error json' do
      expect(perform).to be_json_eql <<-EOS
        {
          "error": {
            "code": 1103,
            "message": "Wrong credentials"
          }
        }
      EOS
    end
  end

  context 'invalid error key' do
    let(:error_key) { :this_is_invalid_error_key }
    it { expect{ subject }.to raise_error(ArgumentError) }
  end
end
