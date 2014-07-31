require 'rails_helper'

describe Api::V1::ResourcesController do
  before { Timecop.freeze(Time.new(2014, 7, 30, 12, 0, 0, "+00:00")) }
  after { Timecop.return }
  let!(:manager) { create(:manager) }
  let!(:current_user) { create(:user, display_name: 'Batman', email: 'batman@cave.com', team: manager.team) }
  let!(:other_user) { create(:user, display_name: 'Robin', email: 'robin@cave.com', team: manager.team) }
  let!(:api_token) { create(:api_token, user: current_user) }
  let!(:product_group_1) { create(:product_group, owner: manager, name: "Group A") }
  let!(:product_group_2) { create(:product_group, owner: manager, name: "Group B") }
  let!(:argument_1) { create(:argument, owner: manager, product_group: product_group_1, feature: 'F #1', benefit: 'B #1') }
  let!(:argument_2) { create(:argument, owner: manager, product_group: product_group_2, feature: 'F #2', benefit: 'B #2') }
  let(:expected_timestamp) { '2014-07-30T12:00:00Z' }

  describe '#index' do
    before { api_authorize_with(api_token.access_token) }

    it 'returns all resources' do
      get :index
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
              "my_team_activity": 0,
              "all_teams_activity": 0
            },
            {
              "id": #{other_user.id},
              "email": "robin@cave.com",
              "display_name": "Robin",
              "avatar_url": null,
              "avatar_thumb_url": null,
              "experience": 0,
              "my_activity": 0,
              "my_team_activity": 0,
              "all_teams_activity": 0
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
              "user_id": #{current_user.id},
              "product_group_id": #{product_group_1.id},
              "rating": 0,
              "my_rating": 0,
              "feature": "F #1",
              "benefit": "B #1",
              "created_at": "#{expected_timestamp}",
              "updated_at": "#{expected_timestamp}"
            },
            {
              "id": #{argument_2.id},
              "user_id": #{current_user.id},
              "product_group_id": #{product_group_2.id},
              "rating": 0,
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
end
