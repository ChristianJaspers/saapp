require 'rails_helper'

describe Manager::UsersController do
  subject { controller }
  render_views

  describe '#index' do
    let(:call_request) { get :index }

    context 'logged in as user' do
      include_context 'user is logged in'
      it_behaves_like 'an action redirecting to', -> { root_path }
    end

    context 'logged in as manager' do
      include_context 'manager is logged in'

      context 'there is one user defined' do
        it_behaves_like 'an action rendering view' do
          let(:view) { 'manager/users/index' }
        end
      end
    end
  end

  describe '#create' do
    include_context 'manager is logged in'

    let(:attributes) do
      {
        email: 'fake@example.com',
        display_name: 'Fake'
      }
    end
    let(:call_request) { post :create, user: attributes }

    it_behaves_like 'an action creating object'
    it_behaves_like 'an action redirecting to', -> { manager_users_path }

    context 'after request' do
      before { call_request }
      let(:user) { User.last }

      it { expect(user.team_id).to eq manager.team_id }
    end
  end

  describe '#update' do
    include_context 'manager is logged in'

    let(:call_request) { patch(:update, id: user.id, user: attributes) }

    context 'changing user to manager' do
      let!(:user) { create(:user, team: manager.team) }
      let(:attributes) do
        {
          manager: '1'
        }
      end
      it { expect { call_request }.to change { user.reload.role }.from('user').to('manager') }
      it { expect { call_request }.to change { user.reload.reset_password_token }.from(nil) }
      it_behaves_like 'an action redirecting to', -> { manager_users_path }
    end

    context 'updating attributes' do
      let!(:user) { create(:user, team: manager.team) }
      let!(:old_email) { user.email }
      let(:attributes) do
        {
          display_name: 'New name',
          email: 'new@email.com'
        }
      end

      it { expect { call_request }.to change { user.reload.email }.from(old_email).to('new@email.com') }
      it_behaves_like 'an action redirecting to', -> { manager_users_path }
    end

    context 'changing role explicitly' do
      let!(:user) { create(:user, team: manager.team) }
      let(:attributes) do
        {
          role: 'manager'
        }
      end

      it 'is not allowed' do
        expect { call_request }.to_not change { user.reload.role }
      end
    end
  end

  describe '#destroy' do
    include_context 'manager is logged in'

    let(:call_request) { delete :destroy, id: user.id }

    context 'user exists' do
      let!(:user) { create(:user, team: manager.team) }

      it { expect { call_request }.to change { user.reload.remove_at }.from(nil) }
    end
  end
end
