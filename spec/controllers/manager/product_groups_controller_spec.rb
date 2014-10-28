require 'rails_helper'

describe Manager::ProductGroupsController do
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
      include_context 'user has active subscription' do
        let(:company_subscription_user) { manager }
      end

      context 'there is one product_group defined' do
        before { create(:product_group, owner: manager) }

        it_behaves_like 'an action rendering view' do
          let(:view) { 'manager/product_groups/index' }
        end
      end
    end
  end

  describe '#create' do
    include_context 'manager is logged in'
    include_context 'user has active subscription' do
      let(:company_subscription_user) { manager }
    end

    let(:attributes){ {name: 'New product_group!'} }
    let(:call_request) { post :create, product_group: attributes }

    it_behaves_like 'an action creating object'

    context 'after request' do
      before { call_request }
      let(:product_group) { ProductGroup.last }

      it { expect(response).to redirect_to(action: 'edit', id: product_group.id) }
    end
  end

  describe '#update' do
    include_context 'manager is logged in'
    include_context 'user has active subscription' do
      let(:company_subscription_user) { manager }
    end

    context 'un-publishing' do
      let!(:product_group) { create(:product_group, owner: manager) }
      let(:call_request) { patch :update, id: product_group.id, product_group: {archive: 'true'} }

      it { expect { call_request }.to change { product_group.reload.archived_at }.from(nil) }
    end

    context 'publishing' do
      let!(:product_group) { create(:product_group, :archived, owner: manager) }
      let(:call_request) { patch :update, id: product_group.id, product_group: {archive: 'false'} }

      it { expect { call_request }.to change { product_group.reload.archived_at }.to(nil) }
    end
  end

  describe '#destroy' do
    include_context 'manager is logged in'
    include_context 'user has active subscription' do
      let(:company_subscription_user) { manager }
    end

    let(:call_request) { delete :destroy, id: product_group.id }

    context 'three product group exist' do
      let!(:product_group_1) { create(:product_group, owner: manager) }
      let!(:product_group_2) { create(:product_group, owner: manager) }
      let!(:product_group_3) { create(:product_group, owner: manager) }
      before { call_request }

      context '1 is removed' do
        let(:product_group) { product_group_1 }

        it { expect(product_group_2.reload.position).to eq 1 }
        it { expect(product_group_3.reload.position).to eq 2 }
      end

      context '2 is removed' do
        let(:product_group) { product_group_2 }

        it { expect(product_group_1.reload.position).to eq 1 }
        it { expect(product_group_3.reload.position).to eq 2 }
      end

      context '3 is removed' do
        let(:product_group) { product_group_3 }

        it { expect(product_group_1.reload.position).to eq 1 }
        it { expect(product_group_2.reload.position).to eq 2 }
      end
    end

    context 'product_group exists' do
      let!(:product_group) { create(:product_group, owner: manager) }

      context 'product_group is removable' do
        before { expect_any_instance_of(ProductGroup).to receive(:removable_by?).with(manager).and_return(true) }

        it { expect { call_request }.to change { product_group.reload.remove_at }.from(nil) }
      end

      context 'product_group is not removable' do
        before { expect_any_instance_of(ProductGroup).to receive(:removable_by?).with(manager).and_return(false) }

        it { expect { call_request }.not_to change { product_group.reload.remove_at }.from(nil) }
      end
    end
  end

  describe '#product_groups' do
    include_context 'manager is logged in'
    include_context 'user has active subscription' do
      let(:company_subscription_user) { manager }
    end

    context 'product_group owned by manager exists' do
      let(:product_group) { create(:product_group, owner: manager) }

      its(:product_groups) { is_expected.to include product_group }
    end

    context "product_group owned by manager's team member exists" do
      let(:team_member) { create(:user, team: manager.team) }
      let(:product_group) { create(:product_group, owner: team_member) }

      its(:product_groups) { is_expected.to include product_group }
    end

    context "product_group owned by user outside of manager's team exists" do
      let(:other_user) { create(:user) }
      let(:product_group) { create(:product_group, owner: other_user) }

      its(:product_groups) { is_expected.not_to include product_group }
    end
  end

  describe '#sort' do
    include_context 'manager is logged in'
    include_context 'user has active subscription' do
      let(:company_subscription_user) { manager }
    end

    let(:call_request) { post :sort, id: product_group, position: position }

    context 'three product groups exist' do
      let!(:product_group_1) { create(:product_group, owner: manager) }
      let!(:product_group_2) { create(:product_group, owner: manager) }
      let!(:product_group_3) { create(:product_group, owner: manager) }
      before { call_request }

      context '1 is moved to the top' do
        let(:product_group) { product_group_1 }
        let(:position) { 1 }

        it { expect(product_group_1.reload.position).to eq 1 }
        it { expect(product_group_2.reload.position).to eq 2 }
        it { expect(product_group_3.reload.position).to eq 3 }
      end

      context '2 is moved to the top' do
        let(:product_group) { product_group_2 }
        let(:position) { 1 }

        it { expect(product_group_1.reload.position).to eq 2 }
        it { expect(product_group_2.reload.position).to eq 1 }
        it { expect(product_group_3.reload.position).to eq 3 }
      end

      context '3 is moved to the top' do
        let(:product_group) { product_group_3 }
        let(:position) { 1 }

        it { expect(product_group_1.reload.position).to eq 2 }
        it { expect(product_group_2.reload.position).to eq 3 }
        it { expect(product_group_3.reload.position).to eq 1 }
      end

      context '1 is moved to the middle' do
        let(:product_group) { product_group_1 }
        let(:position) { 2 }

        it { expect(product_group_1.reload.position).to eq 2 }
        it { expect(product_group_2.reload.position).to eq 1 }
        it { expect(product_group_3.reload.position).to eq 3 }
      end

      context '2 is moved to the middle' do
        let(:product_group) { product_group_2 }
        let(:position) { 2 }

        it { expect(product_group_1.reload.position).to eq 1 }
        it { expect(product_group_2.reload.position).to eq 2 }
        it { expect(product_group_3.reload.position).to eq 3 }
      end

      context '3 is moved to the middle' do
        let(:product_group) { product_group_3 }
        let(:position) { 2 }

        it { expect(product_group_1.reload.position).to eq 1 }
        it { expect(product_group_2.reload.position).to eq 3 }
        it { expect(product_group_3.reload.position).to eq 2 }
      end

      context '1 is moved to the bottom' do
        let(:product_group) { product_group_1 }
        let(:position) { 3 }

        it { expect(product_group_1.reload.position).to eq 3 }
        it { expect(product_group_2.reload.position).to eq 1 }
        it { expect(product_group_3.reload.position).to eq 2 }
      end

      context '2 is moved to the bottom' do
        let(:product_group) { product_group_2 }
        let(:position) { 3 }

        it { expect(product_group_1.reload.position).to eq 1 }
        it { expect(product_group_2.reload.position).to eq 3 }
        it { expect(product_group_3.reload.position).to eq 2 }
      end

      context '3 is moved to the bottom' do
        let(:product_group) { product_group_3 }
        let(:position) { 3 }

        it { expect(product_group_1.reload.position).to eq 1 }
        it { expect(product_group_2.reload.position).to eq 2 }
        it { expect(product_group_3.reload.position).to eq 3 }
      end
    end
  end
end
