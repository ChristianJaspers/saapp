require 'rails_helper'

describe Saasy::BillingForm do
  subject { described_class.new(manager) }
  let(:manager) { create(:manager, email: 'test@example.com') }

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
        contact_fname: ' ',
        contact_lname: ' ',
        referrer: subject.user.id,
        language: subject.user.locale
      }
    end

    context 'user has 1 sales rep' do
      let(:sales_reps_count) { 1 }
      before do
        create(:user, team: manager.team)
      end

      it { expect(perform).to eq expected_params }
    end

    context 'user has 3 sales rep' do
      let(:sales_reps_count) { 3 }
      before do
        3.times do
          create(:user, team: manager.team)
        end
      end

      it { expect(perform).to eq expected_params }
    end
  end

  describe '#payment_url' do
    let(:perform) { subject.payment_url }
    let(:url_base) { 'https://sites.fastspring.com/copenhagenapphouse/checkout/bettersalesman' }
    let(:url_params) { "quantity=3&referrer=#{manager.id}&contact_email=test%40example.com&contact_fname=+&contact_lname=+" }
    let(:expected_url) { "#{url_base}?#{url_params}" }

    context 'user has 3 sales rep' do
      before { create_list(:user, 3, team: manager.team) }

      it { expect(perform).to eq expected_url }
    end
  end
end
