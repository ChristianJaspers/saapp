require 'rails_helper'

describe Api::V1::ProfilesController do
  let(:user) { create(:user, display_name: 'Batman', email: 'a@a.com') }
  let(:api_token) { create(:api_token, user: user) }

  describe '#show' do
    context 'valid access token provided' do
      before { api_authorize_with(api_token.access_token) }

      it 'renders user profile' do
        get :show, {format: :json}
        expect(response).to be_successful
        expect(response.body).to be_json_eql <<-EOS
          {
            "user": {
              "id": #{user.id},
              "email": "a@a.com",
              "display_name": "Batman",
              "avatar_url": null,
              "avatar_thumb_url": null,
              "experience": 0,
              "my_activity": 0,
              "my_team_activity": 0,
              "all_teams_activity": 100
            }
          }
        EOS
      end
    end

    context 'no access' do
      before { get :show, {format: :json} }

      context 'no access token provided' do
        it_behaves_like 'api: forbidden'
      end

      context 'invalid access token provided' do
        before { api_authorize_with('wrong-access-token') }
        it_behaves_like 'api: forbidden'
      end
    end
  end
end
