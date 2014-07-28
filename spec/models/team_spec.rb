require 'rails_helper'

describe Team do
  describe '#score' do
    subject { create(:team) }
    let(:sales_representative_1) { create(:user, team: subject) }
    let(:sales_representative_2) { create(:user, team: subject) }

    context 'two-point scoring exists' do
      before { create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 2) }

      its(:score) { is_expected.to eq 2 }

      context 'additional two-point scoring exists' do
        before { create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 2) }

        its(:score) { is_expected.to eq 4 }
      end

      context 'additional two-point scoring exists for different team member' do
        before { create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 2) }

        its(:score) { is_expected.to eq 4 }
      end

      context 'additional two-point scoring exists for not team member' do
        before { create(:gamification_scoring, beneficiary_id: create(:user).id, amount: 2) }

        its(:score) { is_expected.to eq 2 }
      end
    end
  end

  describe '#goal_score' do
    subject { create(:team) }
    let(:sales_representative_1) { create(:user, team: subject) }
    let(:sales_representative_2) { create(:user, team: subject) }
    let(:sales_representative_3) { create(:user, team: subject) }

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
end
