require 'rails_helper'

describe UserGamificationScoring do
  describe '.results_for_company_user' do
    let(:team) { create(:team) }
    let(:user_1) { create(:user, team: team) }
    let(:user_2) { create(:user, team: team, remove_at: Time.now) }

    before do
      create(:gamification_scoring, beneficiary_id: user_1.id)
      create(:gamification_scoring, beneficiary_id: user_2.id)
    end

    let(:perform) { described_class.results_for_company_user(user_1) }

    it { expect(perform.load.size).to eq 1 }
    it { expect(perform[0].email).to eq user_1.email }
    it { expect(perform[0].score).to eq 1 }
  end
end
