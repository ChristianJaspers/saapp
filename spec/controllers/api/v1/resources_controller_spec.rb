require 'rails_helper'

describe Api::V1::ResourcesController do
  before { travel_to(Time.new(2014, 7, 30, 12, 0, 0, "+00:00")) }
  after { travel_back }
  let!(:manager) { create(:manager) }
  let!(:current_user) { create(:user, display_name: 'Batman', email: 'batman@cave.com', team: manager.team) }
  let!(:other_user) { create(:user, display_name: 'Robin', email: 'robin@cave.com', team: manager.team) }
  let!(:api_token) { create(:api_token, user: current_user) }
  let!(:product_group_1) { create(:product_group, owner: manager, name: "Group A") }
  let!(:product_group_2) { create(:product_group, owner: manager, name: "Group B") }
  let!(:product_group_3) { create(:product_group, owner: manager, name: "Archived", archive: 'true') }
  let!(:argument_1) { create(:argument, owner: manager, product_group: product_group_1, feature: 'F #1', benefit: 'B #1') }
  let!(:argument_2) { create(:argument, owner: manager, product_group: product_group_2, feature: 'F #2', benefit: 'B #2') }
  let(:expected_timestamp) { '2014-07-30T12:00:00Z' }

  describe '#index' do
    it { should route(:post, '/api/v1/resources').to(action: :index, format: :json) }
    it { should route(:get, '/api/v1/resources').to(action: :index, format: :json) }

    let(:call_request) { post :index, {format: :json} }

    context 'valid access token' do
      context 'valid subscription' do
        include_context 'all subscriptions allow to use system'

        before do
          api_authorize_with(api_token.access_token)
          call_request
        end

        it 'returns all resources' do
          expect(response.body).to be_json_eql <<-EOS
            {
              "users": [
                {
                  "id": #{current_user.id},
                  "email": "batman@cave.com",
                  "display_name": "Batman",
                  "avatar_url": null,
                  "avatar_thumb_url": null,
                  "experience": 0,
                  "my_activity": 0,
                  "my_team_activity": 100,
                  "all_teams_activity": 100
                },
                {
                  "id": #{other_user.id},
                  "email": "robin@cave.com",
                  "display_name": "Robin",
                  "avatar_url": null,
                  "avatar_thumb_url": null,
                  "experience": 0,
                  "my_activity": 0,
                  "my_team_activity": 100,
                  "all_teams_activity": 100
                }
              ],
              "product_groups": [
                {
                  "id": #{product_group_1.id},
                  "name": "Group A",
                  "color_hex": "#{Api::ProductGroupSerializer::COLORS.first}",
                  "position": 1
                },
                {
                  "id": #{product_group_2.id},
                  "name": "Group B",
                  "color_hex": "#{Api::ProductGroupSerializer::COLORS.second}",
                  "position": 2
                }
              ],
              "arguments": [
                {
                  "id": #{argument_1.id},
                  "user_id": #{argument_1.owner_id},
                  "product_group_id": #{product_group_1.id},
                  "rating": 0.0,
                  "my_rating": 0,
                  "feature": "F #1",
                  "benefit": "B #1",
                  "created_at": "#{expected_timestamp}",
                  "updated_at": "#{expected_timestamp}"
                },
                {
                  "id": #{argument_2.id},
                  "user_id": #{argument_2.owner_id},
                  "product_group_id": #{product_group_2.id},
                  "rating": 0.0,
                  "my_rating": 0,
                  "feature": "F #2",
                  "benefit": "B #2",
                  "created_at": "#{expected_timestamp}",
                  "updated_at": "#{expected_timestamp}"
                }
              ]
            }
          EOS
        end
      end

      context 'invalid subscription' do
        before do
          api_authorize_with(api_token.access_token)
          call_request
        end

        it 'returns error for invalid subscription' do
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1113,
                "message": "#{ I18n.t('api.errors.no_subscription') }"
              }
            }
          EOS
        end
      end
    end

    context 'invalid access token' do
      before do
        api_authorize_with('invalid')
        call_request
      end

      it_behaves_like 'api: forbidden'
    end
  end
end
