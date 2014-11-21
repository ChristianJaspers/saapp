require 'rails_helper'

shared_examples 'push notification sender initialized with data' do
  context 'after perform' do
    before do
      expect_any_instance_of(PushNotifications::Sender).to receive(:send)
      perform
    end

    it { expect(PushNotifications::Sender).to have_received(:new).with(expected_params) }
  end
end

describe AllArgumentsPerUser do
  let!(:manager) { create(:user, :manager) }
  let!(:argument_1) { create(:argument, owner: manager) }
  let!(:argument_2) { create(:argument, owner: manager) }
  let(:team) { manager.team }

  before do
    allow_any_instance_of(PushNotifications::Sender).to receive(:send)
    allow(PushNotifications::Sender).to receive(:new).and_call_original
  end

  describe '#unrated_arguments_count' do
    let(:perform) { all_arguments_per_user.unrated_arguments_count }
    let(:all_arguments_per_user) { build(:all_arguments_per_user) }

    context 'AR model does not return unrated_arguments_count' do
      it { expect(perform).to eq 0 }
    end

    context 'AR model returns unrated_arguments_count' do
      before do
        allow(all_arguments_per_user).to receive(:[]).with(:unrated_arguments_count).and_return(2)
      end

      it { expect(perform).to eq 2 }
    end
  end

  describe '.send_to_user' do
    let(:perform) { described_class.send_to_user(user_1) }
    let!(:user_1) { create(:user, team: team) }
    let!(:user_2) { create(:user, team: team) }

    context 'no rated arguments' do
      let(:expected_params) do
        {
          user_1.id => 2
        }
      end
      it_behaves_like 'push notification sender initialized with data'
    end

    context 'user has one rated argument' do
      before { create(:argument_rating, argument: argument_1, rater: user_1) }

      let(:expected_params) do
        {
          user_1.id => 1
        }
      end
      it_behaves_like 'push notification sender initialized with data'
    end

    context 'user has two rated argument' do
      before do
        create(:argument_rating, argument: argument_1, rater: user_1)
        create(:argument_rating, argument: argument_2, rater: user_1)
      end

      let(:expected_params) do
        {
          user_1.id => 0
        }
      end
      it_behaves_like 'push notification sender initialized with data'
    end
  end

  describe '.send_to_team' do
    let(:perform) { described_class.send_to_team(user_1.team) }
    let!(:user_1) { create(:user, team: team) }
    let!(:user_2) { create(:user, team: team) }

    context 'no rated arguments' do
      let(:expected_params) do
        {
          user_1.id => 2,
          user_2.id => 2
        }
      end
      it_behaves_like 'push notification sender initialized with data'
    end

    context 'user_1 has one rated argument' do
      before { create(:argument_rating, argument: argument_1, rater: user_1) }

      let(:expected_params) do
        {
          user_1.id => 1,
          user_2.id => 2
        }
      end
      it_behaves_like 'push notification sender initialized with data'
    end

    context 'user_1 has two rated argument' do
      before do
        create(:argument_rating, argument: argument_1, rater: user_1)
        create(:argument_rating, argument: argument_2, rater: user_1)
      end

      let(:expected_params) do
        {
          user_1.id => 0,
          user_2.id => 2
        }
      end
      it_behaves_like 'push notification sender initialized with data'
    end

    context 'all is rated' do
      before do
        create(:argument_rating, argument: argument_1, rater: user_1)
        create(:argument_rating, argument: argument_2, rater: user_1)
        create(:argument_rating, argument: argument_1, rater: user_2)
        create(:argument_rating, argument: argument_2, rater: user_2)
      end

      let(:expected_params) do
        {
          user_1.id => 0,
          user_2.id => 0
        }
      end
      it_behaves_like 'push notification sender initialized with data'
    end
  end

  describe '.map_to_unrated_arguments_for_user' do
    let(:perform) { described_class.map_to_unrated_arguments_for_user(user_1) }
    let!(:user_1) { create(:user, team: team) }
    let!(:user_2) { create(:user, team: team) }

    it do
      expect(perform).to eq({
        user_1.id => 2
      })
    end

    context 'product group is not published' do
      before { argument_2.product_group.update_attribute(:archived_at, Time.now) }

      it do
        expect(perform).to eq({
          user_1.id => 1
        })
      end
    end

    context 'one product group is marked for removal' do
      before { argument_2.product_group.update_column(:remove_at, Time.now) }

      it do
        expect(perform).to eq({
          user_1.id => 1
        })
      end
    end
  end

  describe '.map_to_unrated_arguments_for_team' do
    let(:perform) { described_class.map_to_unrated_arguments_for_team(team) }
    let!(:user_1) { create(:user, team: team) }
    let!(:user_2) { create(:user, team: team) }

    it do
      expect(perform).to eq({
        user_1.id => 2,
        user_2.id => 2,
      })
    end

    context 'product group is not published' do
      before { argument_2.product_group.update_attribute(:archived_at, Time.now) }

      it do
        expect(perform).to eq({
          user_1.id => 1,
          user_2.id => 1,
        })
      end
    end

    context 'one product group is marked for removal' do
      before { argument_2.product_group.update_column(:remove_at, Time.now) }

      it do
        expect(perform).to eq({
          user_1.id => 1,
          user_2.id => 1
        })
      end
    end
  end
end
