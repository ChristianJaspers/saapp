require 'rails_helper'

describe Api::ErrorMapping do
  let(:user) { create(:user) }
  let(:params) { {} }
  before { I18n.locale = I18n.default_locale }
  subject { described_class.new(error_key, user, params) }

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
      it { expect(perform).to eq I18n.t('api.errors.invalid_credentials') }
    end
  end

  describe '#locale' do
    let(:perform) { subject.locale }
    let(:error_key) { :not_authenticated }

    context 'user has no locale' do
      before { allow(user).to receive(:locale).and_return nil }
      it { expect(perform).to eq :en }
    end

    context 'user has locale' do
      before { allow(user).to receive(:locale).and_return 'da' }
      it { expect(perform).to eq :da }
    end

    context 'locale is sent via params' do
      before { params[:device_info] = {locale: 'da'} }
      it { expect(perform).to eq :da }
    end

    context 'invalid locale is sent via params' do
      before { params[:device_info] = {locale: 'xx'} }
      it { expect(perform).to eq :en }
    end

    context 'locale is sent via params but empty' do
      before { params[:device_info] = {locale: ''} }
      it { expect(perform).to eq :en }
    end

    context 'locale is sent via params and user has locale' do
      before do
        params[:device_info] = {locale: 'da'}
        allow(user).to receive(:locale).and_return 'en'
      end

      it 'locale sent via params has highest priority' do
        expect(perform).to eq :da
      end
    end
  end

  describe '#to_hash' do
    let(:perform) { subject.to_hash }
    let(:error_key) { :not_authenticated }

    it 'returns error hash' do
      expect(perform).to eq({
        error: {
          code: 1103,
          message: I18n.t('api.errors.invalid_credentials')
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
            "message": "#{ I18n.t('api.errors.invalid_credentials') }"
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
