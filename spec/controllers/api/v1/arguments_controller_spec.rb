require 'rails_helper'

describe Api::V1::ArgumentsController do
  before { travel_to(Time.new(2014, 7, 30, 12, 0, 0, "+00:00")) }
  after { travel_back }
  let!(:product_group) { create(:product_group, name: "Group A") }
  let!(:current_user) { create(:user, display_name: 'Batman', email: 'batman@cave.com', team: product_group.owner.team) }
  let!(:api_token) { create(:api_token, user: current_user) }

  describe '#create' do
    let(:call_request) { post :create, params, format: 'json' }

    context 'valid api token' do
      before do
        api_authorize_with(api_token.access_token)
        call_request
      end

      context 'valid params' do
        let(:params) do
          {
            feature: 'F',
            benefit: 'B',
            product_group_id: product_group.id
          }
        end

        it { expect(response.status).to eq 201 }
        it { expect(response.body).to have_json_type(Integer).at_path 'argument/id' }
        it { expect(response.body).to have_json_type(String).at_path 'argument/created_at' }
        it { expect(response.body).to have_json_type(String).at_path 'argument/updated_at' }
        it { expect(response.body).to have_json_type(Integer).at_path 'user/id' }

        it do
          expect(response.body).to be_json_eql(<<-EOS
            {
              "argument": {
                "user_id": #{current_user.id},
                "product_group_id": #{product_group.id},
                "rating": 0,
                "my_rating": 0,
                "feature": "F",
                "benefit": "B"
              },
              "user": {
                "display_name": "#{current_user.display_name}",
                "email": "#{current_user.email}",
                "avatar_url": null,
                "avatar_thumb_url": null,
                "experience": 2,
                "my_activity": 50,
                "my_team_activity": 50,
                "all_teams_activity": 50
              }
            }
          EOS
          ).excluding(:id, :created_at, :updated_at)
        end
      end

      context 'missing product group param' do
        let(:params) do
          {
            feature: 'F',
            benefit: 'B'
          }
        end

        it { expect(response.status).to eq 422 }

        it do
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1109,
                "message": "Missing product group"
              }
            }
          EOS
        end
      end

      context 'missing feature param' do
        let(:params) do
          {
            benefit: 'B',
            product_group_id: product_group.id
          }
        end

        it { expect(response.status).to eq 422 }

        it do
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1110,
                "message": "Missing feature or benefit"
              }
            }
          EOS
        end
      end

      context 'missing benefit param' do
        let(:params) do
          {
            feature: 'F',
            product_group_id: product_group.id
          }
        end

        it { expect(response.status).to eq 422 }

        it do
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1110,
                "message": "Missing feature or benefit"
              }
            }
          EOS
        end
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
