require 'rails_helper'

describe SetupNewAccount do
  describe '.call' do
    let(:wizard) { double }
    let(:parameter_object) { double(wizard: wizard) }
    let(:perform) { described_class.call(parameter_object) }

    before { allow(ApplicationMailer).to receive(:user_invitation) }

    context 'manager email is provided' do
      let(:manager_email) { 'manager@saapp.dev' }

      before { allow(wizard).to receive(:email).and_return(manager_email) }

      context 'one product_group with one argument is provided' do
        let(:product_group_name) { 'iPad' }
        let(:feature_description) { 'hi-res screen' }
        let(:benefit_description) { 'more efficient image editing' }
        let(:argument) { double(feature: feature_description, benefit: benefit_description) }
        let(:product_group) { double(name: product_group_name, arguments: [argument]) }

        before { allow(wizard).to receive(:product_groups).and_return([product_group]) }

        context 'one invitation is provided' do
          let(:invitee_email) { 'salesperson@saapp.dev' }
          let(:invitee_display_name) { 'Tony Kane' }
          let(:invitation) { double(email: invitee_email, display_name: invitee_display_name) }

          before { allow(wizard).to receive(:invitations).and_return([invitation]) }

          it { expect { perform }.to change { User.count }.by(2) }
          it { expect { perform }.to change { Team.count }.by(1) }
          it { expect { perform }.to change { Company.count }.by(1) }
          it { expect { perform }.to change { ProductGroup.count }.by(1) }
          it { expect { perform }.to change { Argument.count }.by(1) }

          context 'after perform' do
            before { perform }

            it { expect(ApplicationMailer).to have_received(:user_invitation).with(User.user.last) }

            describe 'manager' do
              subject { User.managers.first }

              it { is_expected.to_not be_nil }
              its(:email) { is_expected.to eq manager_email }
            end

            describe 'invitee' do
              subject { User.users.first }

              it { is_expected.to_not be_nil }
              its(:email) { is_expected.to eq invitee_email }
              its(:display_name) { is_expected.to eq invitee_display_name }
            end

            describe 'product_group' do
              let(:manager) { User.managers.first }

              subject { ProductGroup.first }

              its(:name) { is_expected.to eq product_group_name }
              its(:arguments) { is_expected.to have(1).entry }
              its(:owner) { is_expected.to eq manager }
            end

            describe 'argument' do
              let(:manager) { User.managers.first }

              subject { Argument.first }

              its(:feature) { is_expected.to eq feature_description }
              its(:owner) { is_expected.to eq manager }
              its(:benefit) { is_expected.to eq benefit_description  }
            end           
          end
        end
      end
    end
  end
end
