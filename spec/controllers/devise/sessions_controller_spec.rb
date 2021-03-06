require 'rails_helper'

describe SessionsController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  shared_examples 'user signs in' do
    it 'user is redirect to own namespace' do
      post :create, user: {email: user.email, password: '12345678'}
      expect(response).to redirect_to redirect_path
    end
  end

  shared_examples 'user signs out' do
    before { sign_in user }

    it 'user is redirect to root when logout' do
      post :destroy
      expect(response).to redirect_to '/'
    end
  end

  context 'user login' do
    let(:user) { create(:user) }
    let(:redirect_path) { '/' }
    it_behaves_like 'user signs in'
  end

  context 'manager login' do
    let(:user) { create(:user, :manager) }
    let(:redirect_path) { '/manager' }
    it_behaves_like 'user signs in'
  end

  context 'admin login' do
    let(:user) { create(:user, :admin) }
    let(:redirect_path) { '/admin' }
    it_behaves_like 'user signs in'
  end

  context 'cms editor login' do
    let(:user) { create(:user, :cms_editor) }
    let(:redirect_path) { '/admin' }
    it_behaves_like 'user signs in'
  end

  context 'logout' do
    context 'user logout' do
      let(:user) { create(:user) }
      it_behaves_like 'user signs out'
    end

    context 'manager logout' do
      let(:user) { create(:user, :manager) }
      it_behaves_like 'user signs out'
    end

    context 'admin logout' do
      let(:user) { create(:user, :admin) }
      it_behaves_like 'user signs out'
    end

    context 'cms_editor logout' do
      let(:user) { create(:user, :cms_editor) }
      it_behaves_like 'user signs out'
    end
  end
end
