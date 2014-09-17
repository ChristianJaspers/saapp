shared_context 'manager is logged in' do
  let(:manager) { create(:manager) }
  before { sign_in manager }
end

shared_context 'user is logged in' do
  let(:user) { create(:user) }
  before { sign_in user }
end

shared_context 'user has active subscription' do
  let(:company_subscription) do
    CompanySubscription.new(company_subscription_user)
  end
  before do
    allow(company_subscription).to receive(:can_use_system?).and_return(true)
    ApplicationController.any_instance.stub(:company_subscription) { company_subscription }
  end
end

shared_context 'all subscriptions allow to use system' do
  before do
    allow_any_instance_of(CompanySubscription).to receive(:can_use_system?).and_return(true)
  end
end
