describe Saasy::BillingForm do
  subject { described_class.new(manager) }
  let(:manager) { create(:manager) }

  describe '#action' do
    let(:perform) { subject.action }

    it { expect(perform).to eq 'http://sites.fastspring.com/copenhagenapphouse/api/order' }
  end

  describe '#method' do
    let(:perform) { subject.method }

    it { expect(perform).to eq 'POST' }
  end

  describe '#authenticity_token' do
    let(:perform) { subject.authenticity_token }

    it { expect(perform).to eq false }
  end

  describe '#params' do
    let(:perform) { subject.params }
    let(:expected_params) do
      {
        operation: 'create',
        destination: 'checkout',
        product_1_path: '/bettersalesman',
        product_1_quantity: sales_reps_count,
        contact_email: subject.user.email,
        referrer: subject.user.id,
        language: subject.user.locale
      }
    end

    context 'user has one 1 sales rep' do
      let(:sales_reps_count) { 1 }
      before do
        create(:user, team: manager.team)
      end

      it { expect(perform).to eq expected_params }
    end

    context 'user has one 3 sales rep' do
      let(:sales_reps_count) { 3 }
      before do
        3.times do
          create(:user, team: manager.team)
        end
      end

      it { expect(perform).to eq expected_params }
    end
  end
end
