require 'rails_helper'

describe Company do
  let(:now) { Time.new(2014, 7, 30, 12, 0, 0, "+00:00") }
  let(:manager) { create(:user, :manager) }
  let(:company) { manager.company }
  let(:team) { create(:team, company: company) }
  subject { company }

  describe '#send_removal_reminder!' do
    let(:perform) { subject.send_removal_reminder! }
    before do
      allow_any_instance_of(Saasy::BillingForm).to receive(:payment_url).and_return('http://pay')
      allow(SubscriptionMailSender).to receive(:account_will_be_deleted)
      allow(company).to receive(:clear_removal_reminder!)
    end

    context 'after perform' do
      before { perform }

      it { expect(SubscriptionMailSender).to have_received(:account_will_be_deleted).once.with(manager, 'http://pay') }
      it { expect(company).to have_received(:clear_removal_reminder!).once }
    end
  end

  describe '#lifetime_before_is_removed' do
    let(:perform) { subject.lifetime_before_is_removed }

    it { expect(perform).to eq 30.days }
  end

  describe '#do_not_remove!' do
    before { travel_to(now) }
    after { travel_back }

    let(:remove_at) { now + 30.days }
    let(:perform) { company.do_not_remove! }

    context 'company is removed' do
      before { subject.remove! }

      it { expect { perform }.to change { company.remove_at }.to(nil).from(remove_at.to_date) }
      it { expect { perform }.to change { company.send_removal_reminder_at }.to(nil).from(remove_at.to_date - 7.days) }
    end
  end

  describe '#remove!' do
    before { travel_to(now) }
    after { travel_back }

    let(:remove_at) { now + 30.days }
    let(:perform) { subject.remove! }

    context 'company is not marked as removed' do
      it { expect { perform }.to change { company.remove_at }.to(remove_at.to_date).from(nil) }
      it { expect { perform }.to change { company.send_removal_reminder_at }.to(remove_at.to_date - 7.days).from(nil) }
    end
  end

  describe '#goal_score' do
    let(:sales_representative_1) { create(:user, team: team) }
    let(:sales_representative_2) { create(:user, team: team) }
    let(:sales_representative_3) { create(:user, team: team) }

    context 'sales representatives perform similarly' do
      before do
        create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 20)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 30)
        create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 40)
      end

      it 'goal score is average multiplied by 2' do
        expect(subject.goal_score).to eq 60
      end

      context 'scoring from outside of comparison period is present' do
        before { create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 150, created_at: (Date.today - 8.days)) }

        its(:goal_score) { is_expected.to eq 60 }
      end
    end

    context 'one sales representatives perform extraordinarly' do
      before do
        create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 20)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 30)
        create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 150)
      end

      it 'best sales representative sets the goal score' do
        expect(subject.goal_score).to eq 150
      end
    end
  end

  describe '.overall_goal_score' do
    let(:sales_representative_1) { create(:user, team: team) }
    let(:sales_representative_2) { create(:user, team: team) }
    let(:sales_representative_3) { create(:user, team: team) }

    context 'sales representatives perform similarly' do
      before do
        create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 20)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 30)
        create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 40)
      end

      it 'goal score is average multiplied by 2' do
        expect(described_class.overall_goal_score).to eq 60
      end

      context 'scoring from outside of comparison period is present' do
        before { create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 150, created_at: (Date.today - 8.days)) }

        it { expect(described_class.overall_goal_score).to eq 60 }
      end
    end

    context 'one sales representatives perform extraordinarly' do
      before do
        create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 20)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 30)
        create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 150)
      end

      it 'goal score is average multiplied by 2' do
        expect(described_class.overall_goal_score).to eq ((20 + 30 + 150) / 3.0) * 2
      end
    end
  end
end
