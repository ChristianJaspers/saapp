require 'rails_helper'

describe GoalLevelScore do
  let(:team) { create(:team) }
  let(:sales_representative_1) { create(:user, team: team) }
  let(:sales_representative_2) { create(:user, team: team) }
  let(:sales_representative_3) { create(:user, team: team) }

  describe '.for_platform' do
    subject { GoalLevelScore.for_platform }

    let(:team2) { create(:team) }
    let(:sales_representative_4) { create(:user, team: team2) }
    let(:sales_representative_5) { create(:user, team: team2) }
    let(:sales_representative_6) { create(:user, team: team2) }
    let(:sum) { user_sums.reduce(:+) }
    let(:average) { sum / user_sums.size }

    context 'most sales representatives have lower xp' do
      before do
        create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 10)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 10)
        create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 10)
        create(:gamification_scoring, beneficiary_id: sales_representative_4.id, amount: 10)
        create(:gamification_scoring, beneficiary_id: sales_representative_5.id, amount: 1)
        create(:gamification_scoring, beneficiary_id: sales_representative_5.id, amount: 1)
        create(:gamification_scoring, beneficiary_id: sales_representative_6.id, amount: 30)
      end

      let(:user_sums) { [10, 10, 10, 10, (1 + 1), 30] }

      it 'platform goal score is always average of sums multiplied by 2 per user scope' do
        expect(subject).to eq average * 2
      end
    end

    context 'most sales representatives have higher xp' do
      before do
        create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 50)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 50)
        create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 50)
        create(:gamification_scoring, beneficiary_id: sales_representative_4.id, amount: 50)
        create(:gamification_scoring, beneficiary_id: sales_representative_5.id, amount: 1)
        create(:gamification_scoring, beneficiary_id: sales_representative_5.id, amount: 1)
        create(:gamification_scoring, beneficiary_id: sales_representative_6.id, amount: 50)
      end

      let(:user_sums) { [50, 50, 50, 50, (1 + 1), 50] }

      it 'platform goal score is always average of sums multiplied by 2 per user scope' do
        expect(subject).to eq average * 2
      end
    end
  end

  describe '.for_company' do
    subject { GoalLevelScore.for_company(team.company) }

    context 'most sales representatives have lower xp' do
      before do
        create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 10)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 5)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 5)
        create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 50)
      end

      it 'maximum sum of users xp is considered a goal level' do
        expect(subject).to eq 50
      end
    end

    context 'most sales representatives have higher xp' do
      before do
        create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 50)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 50)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 50)
        create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 100)
      end

      let(:average) { (50 + (50 + 50) + 100) / 3.0 }

      it 'average of sums multiplied by 2 is considered a goal level' do
        expect(subject).to eq average * 2
      end
    end
  end

  describe '.for_team' do
    subject { GoalLevelScore.for_company(team) }

    context 'most sales representatives have lower xp' do
      before do
        create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 20)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 5)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 5)
        create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 70)
      end

      it 'maximum sum of users xp is considered a goal level' do
        expect(subject).to eq 70
      end
    end

    context 'most sales representatives have higher xp' do
      before do
        create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 10)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 40)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 30)
        create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 70)
      end

      it 'average of sums multiplied by 2 is considered a goal level' do
        expect(subject).to eq ((10 + (40 + 30) + 70) / 3.0) * 2
      end
    end
  end

  describe '.my_team_activity' do
    subject { GoalLevelScore.my_team_activity(team) }

    context 'most sales representatives have lower xp' do
      before do
        create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 20)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 5)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 5)
        create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 70)
      end

      it do
        expect(subject).to eq (((20 / 70.0) + ((5 + 5) / 70.0) + (70 / 70.0)) * 100.0 / 3)
      end
    end

    context 'most sales representatives have higher xp' do
      before do
        create(:gamification_scoring, beneficiary_id: sales_representative_1.id, amount: 10)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 40)
        create(:gamification_scoring, beneficiary_id: sales_representative_2.id, amount: 30)
        create(:gamification_scoring, beneficiary_id: sales_representative_3.id, amount: 70)
      end

      it do
        expect(subject).to eq ((10 / 70.0) + ((40 + 30) / 70.0) + (70 / 70.0)) * 100.0 / 3
      end
    end
  end
end
