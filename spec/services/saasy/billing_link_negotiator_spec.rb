describe Saasy::BillingLinkNegotiator do
  let(:company_subscription) { build(:company_subscription) }
  subject { described_class.new(company_subscription) }

  describe '#link' do
    let(:perform) { subject.link }
    before do
      allow(subject).to receive(:submit_form_link).and_return('partial')
      allow(subject).to receive(:saasy_subscription_link).and_return('link')
    end

    context 'render form returns true' do
      before { allow(subject).to receive(:render_form?).and_return(true) }
      it { expect(perform).to eq 'partial' }
    end

    context 'render form returns false' do
      before { allow(subject).to receive(:render_form?).and_return(false) }
      it { expect(perform).to eq 'link' }
    end
  end

  describe '#render_form?' do
    let(:subscription) { create(:subscription) }
    let(:perform) { subject.render_form? }

    context 'subscription exists' do
      before do
        allow(company_subscription).to receive(:needs_to_buy_subscription?).and_return(false)
      end

      it { expect(perform).to be_falsey }
    end

    context 'no active subscription' do
      before do
        allow(company_subscription).to receive(:needs_to_buy_subscription?).and_return(true)
      end

      it { expect(perform).to be_truthy }
    end
  end
end
