require "rails_helper"

describe HomeController do
  render_views

  describe '#show' do
    let(:call_request){ get :show }

    it { expect(call_request).to be_success }
    it_behaves_like 'an action rendering view'
  end
end
