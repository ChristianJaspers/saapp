require 'rails_helper'

describe SetupNewAccount do
  describe '.call' do
    let(:wizard){ double }
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
        end
      end
    end
  end
end
