require 'rails_helper'

describe LanguagesController do
  render_views

  describe '#update' do
    let(:call_request) { patch :update, params }

    context 'guest access' do
      before { call_request }

      context 'guest chooses en' do
        let(:params) { {lang: 'en'} }

        it { expect(response.code).to eq '302' }
        it { expect(response.cookies['lang']).to eq 'en' }
      end

      context 'guest chooses da' do
        let(:params) { {lang: 'da'} }

        it { expect(response.code).to eq '302' }
        it { expect(response.cookies['lang']).to eq 'da' }
      end
    end

    context 'manager access' do
      include_context 'manager is logged in'
      before { call_request }

      context 'manager chooses en' do
        let(:params) { {lang: 'en'} }

        it { expect(response.code).to eq '302' }
        it { expect(response.cookies['lang']).to eq 'en' }
        it { expect(manager.reload.locale).to eq 'en' }
      end

      context 'manager chooses da' do
        let(:params) { {lang: 'da'} }

        it { expect(response.code).to eq '302' }
        it { expect(response.cookies['lang']).to eq 'da' }
        it { expect(manager.reload.locale).to eq 'da' }
      end
    end
  end
end
