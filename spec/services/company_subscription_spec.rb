describe CompanySubscription do
  subject { described_class.new(user) }
  let(:user) { create(:manager) }

  describe '#can_use_system?' do
    let(:perform) { subject.can_use_system? }
    let(:subscription) { create(:subscription, company: user.company, referrer: user) }

    context 'active subscription exist' do
      before { allow(subject).to receive(:active_subscription).and_return(subscription) }

      it { expect(perform).to eq true }
    end

    context 'active subscription does not exist' do
      before { allow(subject).to receive(:active_subscription).and_return(nil) }

      it { expect(perform).to eq false }
    end
  end

  describe '#needs_to_buy_subscription?' do
    let(:perform) { subject.needs_to_buy_subscription? }
    let(:subscription) { create(:subscription, company: user.company, referrer: user) }

    context 'active remote subscription exist' do
      before { allow(subject).to receive(:active_remote_subscription).and_return(subscription) }

      it { expect(perform).to eq false }
    end

    context 'active remote subscription does not exist' do
      before { allow(subject).to receive(:active_remote_subscription).and_return(nil) }

      it { expect(perform).to eq true }
    end
  end

  describe '#display_reminder?' do
    let(:perform) { subject.display_reminder? }
    let(:subscription) { create(:subscription, company: user.company, referrer: user) }

    context 'no subscription' do
      before { allow(subject).to receive(:active_subscription).and_return(nil) }

      it { expect(perform).to be_falsey }
    end

    context 'subscription exists' do
      before { allow(subject).to receive(:active_subscription).and_return(subscription) }

      context 'subscription but no trial' do
        before { allow(subscription).to receive(:trial?).and_return(false) }

        it { expect(perform).to be_falsey }
      end

      context 'trail subscription but ends later' do
        before do
          allow(subscription).to receive(:trial?).and_return(false)
          allow(subscription).to receive(:ends_within_week?).and_return(false)
        end

        it { expect(perform).to be_falsey }
      end

      context 'valid subscription' do
        before do
          allow(subscription).to receive(:trial?).and_return(true)
          allow(subscription).to receive(:ends_within_week?).and_return(true)
        end

        it { expect(perform).to be_truthy }
      end
    end
  end

  describe '#link_negotiator' do
    let(:perform) { subject.link_negotiator }

    it 'returns instance of link negotiator' do
      expect(perform).to be_kind_of(Saasy::BillingLinkNegotiator)
    end
  end

  describe '#billing_form' do
    let(:perform) { subject.billing_form }

    it 'returns instance of billing form' do
      expect(perform).to be_kind_of(Saasy::BillingForm)
    end
  end

  describe '#active_subscription' do
    let(:perform) { subject.active_subscription }

    pending 'this is super important'
  end

  describe '#active_remote_subscription' do
    let(:perform) { subject.active_remote_subscription }

    pending 'this is super important'
  end
end
