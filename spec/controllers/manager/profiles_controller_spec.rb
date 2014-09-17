require 'rails_helper'

describe Manager::ProfilesController do
  subject { controller }
  render_views

  describe '#update' do
    include_context 'manager is logged in'
    include_context 'user has active subscription' do
      let(:company_subscription_user) { manager }
    end

    let(:call_request) { patch(:update, user: attributes) }

    context 'updating user' do
      let(:attributes) do
        {
          display_name: 'Abc',
          address: 'Home'
        }
      end

      it { expect { call_request }.to change { manager.reload.display_name }.to('Abc') }
      it { expect { call_request }.to change { manager.reload.address }.to('Home') }
      it_behaves_like 'an action redirecting to', -> { edit_manager_profile_path }
    end

    context 'changing other params' do
      let(:attributes) do
        {
          role: 'manager'
        }
      end

      it 'is not allowed' do
        expect { call_request }.to_not change { manager.reload.role }
      end
    end
  end
end
