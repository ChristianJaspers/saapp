require 'rails_helper'

describe Manager::DestroyUser do
  describe '.call' do
    let(:user) { create(:user) }
    let(:parameter_object) { double(user: user) }
    let(:perform) { described_class.call(parameter_object) }

    before do
      allow(user).to receive(:remove!).and_call_original
      allow_any_instance_of(SubscriptionUpdater).to receive(:success?).and_return(true)
      allow_any_instance_of(SubscriptionUpdater).to receive(:update_remote_subscription).and_return(true)
      allow(SubscriptionUpdater).to receive(:call).and_call_original
    end

    context 'after perform' do
      before { perform }

      it { expect(user).to have_received(:remove!).once }
      it { expect(SubscriptionUpdater).to have_received(:call).with(company: user.company).once }
    end
  end
end
