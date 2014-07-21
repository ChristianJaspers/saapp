require 'rails_helper'

describe Manager::CategoriesController do
  subject { controller }
  render_views

  describe '#index' do
    let(:call_request) { get :index }

    context 'logged in as user' do
      let(:user) { create(:user) }
      before { sign_in user }

      it_behaves_like 'an action redirecting to', -> { root_path }
    end

    context 'logged in as manager' do
      let(:manager) { create(:manager) }
      before { sign_in manager }

      context 'there is one category defined' do
        before { create(:category, owner: manager) }

        it_behaves_like 'an action rendering view' do
          let(:view) { 'manager/categories/index' }
        end
      end
    end
  end

  describe '#categories' do
    context 'manager is logged in' do
      let(:manager) { create(:manager) }
      before { sign_in manager }

      context 'category owned by manager exists' do
        let(:category) { create(:category, owner: manager) }

        its(:categories) { is_expected.to include category }
      end

      context "category owned by manager's team member exists" do
        let(:team_member) { create(:user, team: manager.team) }
        let(:category) { create(:category, owner: team_member) }

        its(:categories) { is_expected.to include category }
      end

      context "category owned by user outside of manager's team exists" do
        let(:other_user) { create(:user) }
        let(:category) { create(:category, owner: other_user) }

        its(:categories) { is_expected.not_to include category }
      end
    end
  end
end
