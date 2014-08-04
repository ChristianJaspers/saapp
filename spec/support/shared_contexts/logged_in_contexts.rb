shared_context 'manager is logged in' do
  let(:manager) { create(:manager) }
  before { sign_in manager }
end

shared_context 'user is logged in' do
  let(:user) { create(:user) }
  before { sign_in user }
end
