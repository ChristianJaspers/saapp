require 'rails_helper'

describe Api::UserSerializer do
  let(:current_user) { create(:user) }
  let(:serializer) { described_class.new(current_user) }
  before { allow_any_instance_of(described_class).to receive(:current_user).and_return(current_user) }

  subject { serializer }

  describe '#my_activity' do
    context 'team goal score is 0' do
      before { allow(GoalLevelScore).to receive(:for_team).and_return(0) }

      its(:my_activity) { is_expected.to eq 0 }
    end

    context 'team goal score is 200' do
      before { allow(GoalLevelScore).to receive(:for_team).and_return(200) }

      context 'my score in comparison period is 20' do
        before { allow(current_user).to receive(:score_in_period).and_return(20) }

        its(:my_activity) { is_expected.to eq 10 }
      end
    end
  end

  describe '#my_team_activity' do
    context 'company goal score is 0' do
      before { allow(GoalLevelScore).to receive(:for_company).and_return(0) }

      its(:my_team_activity) { is_expected.to eq 0 }
    end

    context 'company goal score is 200' do
      before { allow(GoalLevelScore).to receive(:for_company).and_return(200) }

      context 'my team score in comparison period is 20' do
        before { allow_any_instance_of(Team).to receive(:score_in_period).and_return(20) }

        its(:my_team_activity) { is_expected.to eq 10 }
      end
    end
  end

  describe '#all_teams_activity' do
    context 'overall goal score is 0' do
      before { allow(GoalLevelScore).to receive(:for_platform).and_return(0) }

      its(:all_teams_activity) { is_expected.to eq 0 }
    end

    context 'overall goal score is 200' do
      before { allow(GoalLevelScore).to receive(:for_platform).and_return(200) }

      context 'my company score in comparison period is 20' do
        before { allow_any_instance_of(Company).to receive(:score_in_period).and_return(20) }

        its(:all_teams_activity) { is_expected.to eq 10 }
      end
    end
  end
end
