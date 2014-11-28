require 'rails_helper'

describe Manager::DestroyArgument do
  describe '.call' do
    let(:product_group_company_1) { create(:product_group) }
    let(:product_group_company_2) { create(:product_group) }
    let(:current_user) { product_group_company_1.owner }
    let(:other_company_user) { product_group_company_2.owner }
    let!(:argument_company_1) { create(:argument, product_group: product_group_company_1, owner: current_user) }
    let!(:argument_company_2) { create(:argument, product_group: product_group_company_2, owner: other_company_user) }

    let(:parameter_object) { double(current_user: current_user, params: params) }
    let(:perform) { described_class.call(parameter_object).success? }

    before { allow(AllArgumentsPerUser).to receive(:send_to_team).and_call_original }

    context 'deleting argument from your company' do
      let(:params) { {id: argument_company_1.id} }

      it { expect(perform).to be_truthy }

      context 'after perform' do
        before { perform }

        it { expect(AllArgumentsPerUser).to have_received(:send_to_team) }
      end
    end

    context 'deleting argument from different company' do
      let(:params) { {id: argument_company_2.id} }

      it { expect(perform).to be_falsey }

      context 'after perform' do
        before { perform }

        it { expect(AllArgumentsPerUser).to_not have_received(:send_to_team) }
      end
    end
  end
end
