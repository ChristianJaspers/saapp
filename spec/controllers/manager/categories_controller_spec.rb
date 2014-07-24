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
      include_context 'manager is logged in'

      context 'there is one category defined' do
        before { create(:category, owner: manager) }

        it_behaves_like 'an action rendering view' do
          let(:view) { 'manager/categories/index' }
        end
      end
    end
  end

  describe '#update' do
    include_context 'manager is logged in'

    let(:call_request) { post :create, category: {name: 'New category!'} }

    context 'after request' do
      before { call_request }
      let(:category) { Category.last }

      it { expect(response).to redirect_to(action: 'edit', id: category.id) }
      it { expect(Category).to exist.with(name: 'New category!') }
      it { expect(category.owner).to eq manager }
    end
  end

  describe '#update' do
    include_context 'manager is logged in'

    context 'un-publishing' do
      let!(:category) { create(:category, owner: manager) }
      let(:call_request) { patch :update, id: category.id, category: {archive: 'true'} }

      it { expect { call_request }.to change { category.reload.archived_at }.from(nil) }
    end

    context 'publishing' do
      let!(:category) { create(:category, :archived, owner: manager) }
      let(:call_request) { patch :update, id: category.id, category: {archive: 'false'} }

      it { expect { call_request }.to change { category.reload.archived_at }.to(nil) }
    end
  end

  describe '#destroy' do
    include_context 'manager is logged in'

    let(:call_request) { delete :destroy, id: category.id }

    context 'category exists' do
      let!(:category) { create(:category, owner: manager) }

      context 'category is removable' do
        before { expect_any_instance_of(Category).to receive(:removable_by?).with(manager).and_return(true) }

        it { expect { call_request }.to change { category.reload.remove_at }.from(nil) }
      end

      context 'category is not removable' do
        before { expect_any_instance_of(Category).to receive(:removable_by?).with(manager).and_return(false) }

        it { expect { call_request }.not_to change { category.reload.remove_at }.from(nil) }
      end
    end
  end

  describe '#categories' do
    include_context 'manager is logged in'

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
