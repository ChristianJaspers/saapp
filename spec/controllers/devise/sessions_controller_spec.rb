require 'rails_helper'

describe Devise::SessionsController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  shared_examples 'user signs in' do
    it 'user is redirect to own namespace' do
      post :create, user: {email: user.email, password: '12345678'}
      expect(response).to redirect_to redirect_path
    end
  end

  context 'user login' do
    let(:user) { create(:user) }
    let(:redirect_path) { '/' }
    it_behaves_like 'user signs in'
  end

  context 'manager login' do
    let(:user) { create(:user, :manager) }
    let(:redirect_path) { '/' }
    it_behaves_like 'user signs in'
  end

  context 'admin login' do
    let(:user) { create(:user, :admin) }
    let(:redirect_path) { '/admin' }
    it_behaves_like 'user signs in'
  end

  context 'user logout' do
    let(:user) { create(:user) }
    let(:redirect_path) { '/' }
    it_behaves_like 'user signs in'
  end

  context 'manager logout' do
    let(:user) { create(:user, :manager) }
    let(:redirect_path) { '/' }
    it_behaves_like 'user signs in'
  end

  context 'admin logout' do
    let(:user) { create(:user, :admin) }
    let(:redirect_path) { '/admin' }
    it_behaves_like 'user signs in'
  end
end
