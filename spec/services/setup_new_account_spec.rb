require 'rails_helper'

describe SetupNewAccount do
  describe '.call' do
    let(:wizard) { double }
    let(:parameter_object) { double(wizard: wizard) }
    let(:perform) { described_class.call(parameter_object) }

    context 'manager email is provided' do
      let(:manager_email) { 'manager@saapp.dev' }

      before { allow(wizard).to receive(:email).and_return(manager_email) }

      context 'one category with one argument is provided' do
        let(:category_name) { 'iPad' }
        let(:feature_description) { 'hi-res screen' }
        let(:benefit_description) { 'more efficient image editing' }
        let(:argument) { double(feature: feature_description, benefit: benefit_description) }
        let(:category) { double(name: category_name, arguments: [argument]) }

        before { allow(wizard).to receive(:categories).and_return([category]) }

        context 'one invitation is provided' do
          let(:invitee_email) { 'salesperson@saapp.dev' }
          let(:invitee_display_name) { 'Tony Kane' }
          let(:invitation) { double(email: invitee_email, display_name: invitee_display_name) }

          before { allow(wizard).to receive(:invitations).and_return([invitation]) }

          it { expect { perform }.to change { User.count }.by(2) }
          it { expect { perform }.to change { Team.count }.by(1) }
          it { expect { perform }.to change { Company.count }.by(1) }
          it { expect { perform }.to change { Category.count }.by(1) }
          it { expect { perform }.to change { Feature.count }.by(1) }
          it { expect { perform }.to change { Benefit.count }.by(1) }

          context 'after perform' do
            before { perform }

            describe 'manager' do
              subject { User.manager.first }

              it { is_expected.to_not be_nil }
              its(:email) { is_expected.to eq manager_email }
            end

            describe 'invitee' do
              subject { User.user.first }

              it { is_expected.to_not be_nil }
              its(:email) { is_expected.to eq invitee_email }
            end

            describe 'category' do
              let(:manager) { User.manager.first }

              subject { Category.first }

              its(:name) { is_expected.to eq category_name }
              its(:features) { is_expected.to have(1).entry }
              its(:owner) { is_expected.to eq manager }
            end

            describe 'feature' do
              let(:manager) { User.manager.first }

              subject { Feature.first }

              its(:description) { is_expected.to eq feature_description }
              its(:owner) { is_expected.to eq manager }
              its(:benefit) { is_expected.to_not be_nil }
            end

            describe 'benefit' do
              subject { Benefit.first }

              its(:description) { is_expected.to eq benefit_description }
            end
          end
        end
      end
    end
  end
end
