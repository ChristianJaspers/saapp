shared_context 'manager is logged in' do
  let(:manager) { create(:manager) }
  before { sign_in manager }
end
