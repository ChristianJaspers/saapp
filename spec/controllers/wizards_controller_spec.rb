require "rails_helper"

describe WizardsController do
  render_views

  describe '#create' do
    let(:call_request) { post :create, attributes }

    context 'valid email is provided' do
      let(:attributes) { {wizard: {email: 'person@example.dev'}} }

      it { expect(call_request).to be_success }

      it_behaves_like 'an action rendering view'
    end

    context 'no email is provided' do
      let(:attributes) { {wizard: {email: ''}} }

      it { expect(call_request).to be_success }

      it_behaves_like 'an action rendering view' do
        let(:view) { 'home/show' }
      end
    end

    context 'invalid email is provided' do
      let(:attributes) { {wizard: {email: 'person'}} }

      it { expect(call_request).to be_success }

      it_behaves_like 'an action rendering view' do
        let(:view) { 'home/show' }
      end
    end
  end
end
