require 'rails_helper'

describe Api::Authentication do
  subject { described_class.new(access_token) }
  describe '#authenticate!' do
    context 'good api token is used' do
      let(:api_token) { create(:api_token) }
      let(:access_token) { api_token.access_token }

      context 'active subscription exists' do
        include_context 'all subscriptions allow to use system'

        its(:authenticate!) { should be_truthy }
        its(:user) { should eq api_token.user }
      end

      context 'no subscription' do
        its(:authenticate!) { should be_falsey }
        its(:user) { should be_nil }
      end
    end

    context 'wrong api token is used' do
      let(:api_token) { create(:api_token) }
      let(:access_token) { '123' }

      its(:authenticate!) { should be_falsey }
      its(:user) { should be_nil }
    end
  end
end
