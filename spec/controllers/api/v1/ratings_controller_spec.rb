require 'rails_helper'

shared_examples 'rated argument by user' do
  it do
    expect(response.body).to be_json_eql <<-EOS
      {
        "user": {
          "id": #{current_user.id},
          "email": "batman@cave.com",
          "display_name": "Batman",
          "avatar_url": null,
          "avatar_thumb_url": null,
          "experience": #{expected_values[:experience]},
          "my_activity": #{expected_values[:my_activity]},
          "my_team_activity": #{expected_values[:my_team_activity]},
          "all_teams_activity": #{expected_values[:all_teams_activity]}
        },
        "argument": {
          "id": #{argument.id},
          "user_id": #{argument.owner_id},
          "product_group_id": #{product_group.id},
          "rating": #{expected_values[:rating]},
          "my_rating": #{expected_values[:my_rating]},
          "feature": "F #1",
          "benefit": "B #1",
          "created_at": "#{expected_timestamp}",
          "updated_at": "#{expected_timestamp}"
        }
      }
    EOS
  end

end

describe Api::V1::RatingsController do
  before { travel_to(Time.new(2014, 7, 30, 12, 0, 0, "+00:00")) }
  after { travel_back }
  let!(:manager) { create(:manager) }
  let!(:current_user) { create(:user, display_name: 'Batman', email: 'batman@cave.com', team: manager.team) }
  let!(:api_token) { create(:api_token, user: current_user) }
  let!(:product_group) { create(:product_group, owner: manager, name: "Group A") }
  let!(:argument) { create(:argument, owner: manager, product_group: product_group, feature: 'F #1', benefit: 'B #1') }
  let(:expected_timestamp) { '2014-07-30T12:00:00Z' }

  describe '#create' do
    let(:call_request) { post :create, params.merge(argument_id: argument.id) }

    context 'valid api token' do
      before do
        api_authorize_with(api_token.access_token)
        call_request
      end

      context 'user rates 1' do
        let(:params) { {rating: 1} }
        let(:expected_values) do
          {
            experience: 2,
            my_activity: 50,
            my_team_activity: 100,
            all_teams_activity: 100,
            rating: 1,
            my_rating: 1
          }
        end

        it_behaves_like 'rated argument by user'
      end

      context 'user rates 2' do
        let(:params) { {rating: 2} }
        let(:expected_values) do
          {
            experience: 2,
            my_activity: 50,
            my_team_activity: 150,
            all_teams_activity: 150,
            rating: 2,
            my_rating: 2
          }
        end

        it_behaves_like 'rated argument by user'
      end

      context 'user rates 3' do
        let(:params) { {rating: 3} }
        let(:expected_values) do
          {
            experience: 2,
            my_activity: 33,
            my_team_activity: 133,
            all_teams_activity: 200,
            rating: 3,
            my_rating: 3
          }
        end

        it_behaves_like 'rated argument by user'
      end
    end

    context 'invalid api token' do
      before { call_request }
      let(:params) { {} }

      it { expect(response.status).to eq 403 }

      it do
        expect(response.body).to be_json_eql <<-EOS
          {
            "error": {
              "code": 1010,
              "message": "You don't have access"
            }
          }
        EOS
      end
    end
  end
end
